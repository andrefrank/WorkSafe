//
//  CaptureSession.swift
//  Moody
//
//  Created by Florian on 19/05/15.
//  Copyright (c) 2015 objc.io. All rights reserved.
//

import AVFoundation
import MobileCoreServices
import Photos
import UIKit

protocol CapturePhotoServiceDelegate: class {
    func capturePhotoDidChangeAuthorizationStatus(authorized: Bool, forType type:CapturePhotoService.CaptureType)
    func capturePhotoDidCapture(_ image: UIImage?)
}

class CapturePhotoService: NSObject {
    enum CaptureType {
        case Camera
        case PhotoLibrary
    }
    
    var isAuthorized: Bool {
        switch captureType {
        case .Camera:
            return AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized
        case .PhotoLibrary:
            return PHPhotoLibrary.authorizationStatus() == .authorized
        }
    }
    
    var isReady:Bool {
        switch captureType{
        case .Camera:
            return UIImagePickerController.isSourceTypeAvailable(.camera)
        case .PhotoLibrary:
            return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        }
    }
    
    init(delegate: CapturePhotoServiceDelegate, withType type: CaptureType) {
        self.delegate = delegate
        captureType = type
        
        super.init()
        
        if isAuthorized {
            setup()
        } else {
            requestAuthorization()
        }
    }
    
    func captureImage() {
        guard (delegate != nil),let controller=delegate as? UIViewController else {return}
        controller.present(imagePicker, animated: true,completion: nil)
    }
    
    // MARK: - Private
    
    fileprivate weak var delegate: CapturePhotoServiceDelegate!
    fileprivate let captureType: CaptureType
    fileprivate let imagePicker=UIImagePickerController()
    
    fileprivate func setup() {
        guard isReady else {return}
        
        switch captureType{
        case .Camera:
            setupCamera()
        case .PhotoLibrary:
            setupPhotoLibrary()
        }
        
    }
    
    fileprivate func setupCamera(){
        imagePicker.delegate=self
        imagePicker.allowsEditing=true
        //Source type must be set first before any other properties can be set
        imagePicker.sourceType = .camera
        imagePicker.showsCameraControls=true
        
        imagePicker.cameraDevice = .rear
        imagePicker.mediaTypes = [kUTTypeImage] as [String]
    }
    
    fileprivate func setupPhotoLibrary(){
        imagePicker.delegate=self
        imagePicker.allowsEditing=true
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage] as [String]
        
    }
    
    fileprivate func requestAuthorization() {
        if captureType == .Camera {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { authorized in
                DispatchQueue.main.async {
                    self.delegate.capturePhotoDidChangeAuthorizationStatus(authorized: authorized, forType: .Camera)
                    guard authorized else { return }
                    self.setup()
                }
            }
        } else if captureType == .PhotoLibrary {
            PHPhotoLibrary.requestAuthorization { authorized in
                DispatchQueue.main.async {
                    self.delegate.capturePhotoDidChangeAuthorizationStatus(authorized: authorized == .authorized, forType: .PhotoLibrary)
                    guard authorized == .authorized else { return }
                    self.setup()
                }
            }
        }
    }
}

extension CapturePhotoService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        picker.dismiss(animated: true)
        
         if info[UIImagePickerController.InfoKey.mediaType] as! CFString == kUTTypeImage {
            delegate.capturePhotoDidCapture((info[.editedImage] as! UIImage))
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
