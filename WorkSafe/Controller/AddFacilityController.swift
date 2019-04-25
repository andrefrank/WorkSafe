//
//  AddFacilityController.swift
//  WorkSafe
//
//  Created by Andre Frank on 22.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import CoreData
import UIKit

class AddFacilityController: UITableViewController, CapturePhotoServiceDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet var departmentTextField: UITextField!
    @IBOutlet var floorLevelTextField: UITextField!
    @IBOutlet var roomNumberTextField: UITextField!
    @IBOutlet var facilityImageView: UIImageView!
    
    // MARK: - Public properties
    var facilitiy: Facility?
    var managedContext: NSManagedObjectContext!
    var imageCompletionHandler:((UIImage)->Void)?
    
    typealias ActionSheetHandler = (UIAlertAction) -> Void
    
    // MARK: -Private properties
    private var capturePhotoService: CapturePhotoService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFacilityDataToGUI()
        setupGesture()
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        facilityImageView.addGestureRecognizer(tapGesture)
        facilityImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleTapGesture(gesture: UITapGestureRecognizer) {
        showImageSourceSelectionSheet(selectionPhotoLibrary: { _ in
            let capturePhoto = CapturePhotoService(delegate: self, withType: .PhotoLibrary)
            self.capturePhotoService = capturePhoto
            self.capturePhotoService?.captureImage()
        }) { _ in
            let capturePhoto = CapturePhotoService(delegate: self, withType: .Camera)
            self.capturePhotoService = capturePhoto
            self.capturePhotoService?.captureImage()
        }
    }
    
    func capturePhotoDidCapture(_ image: UIImage?) {
        facilityImageView.image = image
    }
    
    func capturePhotoDidChangeAuthorizationStatus(authorized: Bool, forType type: CapturePhotoService.CaptureType) {
        if type == .Camera {
            print("Access has changed for camera")
        } else {
            print("Acces has changed for Photo Library")
        }
    }
    
    func showImageSourceSelectionSheet(selectionPhotoLibrary: @escaping ActionSheetHandler, selectionCamera: @escaping ActionSheetHandler) {
        let actionSheet = UIAlertController(title: "Add Photo", message: "Use PhotoLibrary or camera", preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: selectionPhotoLibrary)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: selectionCamera)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func loadFacilityDataToGUI() {
        guard let fac = facilitiy else { return }
        roomNumberTextField.text = fac.roomNumber
        departmentTextField.text = fac.department
        floorLevelTextField.text = "\(fac.floor)"
        
        if let photoURL = fac.photoURL{
            facilityImageView.image = UIImage.loadImageFromUserDirectory(photoURL: photoURL)
        }else{
            facilityImageView.image=UIImage(named: "camera")
        }
    }
    
    private func changeFacility(fac:Facility){
        managedContext.performChanges { [unowned self] in
            fac.department = self.departmentTextField.text ?? "Department"
            fac.floor = Int16(self.floorLevelTextField.text ?? "0")!
            fac.roomNumber = self.roomNumberTextField.text ?? ""
            
            //Only save a new image if the user has an image selected and the department is valid
            guard let image=self.facilityImageView.image, let department=self.departmentTextField.text else {return}
            
            fac.photoURL=image.saveToUserDirectory(pathComponent: department, filename:"Test.jpg")
            //print(fac.photoURL)
        }
    }
    
    private func addFacility(){
        managedContext.performChanges { [weak self] in
            
            //Only save a new image if the user has an image selected and the department is valid
            var photoURL:String?
            
            if let image=self?.facilityImageView.image, let department=self?.departmentTextField.text {
                 photoURL=image.saveToUserDirectory(pathComponent:department, filename:"Test.jpg")
                //print(photoURL)
            }
            
            guard let mySelf=self else {return}
            _ = Facility.insert(into: mySelf.managedContext, department: self?.departmentTextField.text ?? "Department", photoURL:photoURL, roomNumber: self?.roomNumberTextField.text ?? "", floor: Int16(self?.floorLevelTextField.text ?? "0")!)
        }
    }
    
    private func saveGUIToFacility() {
        if let fac = self.facilitiy {
            changeFacility(fac: fac)
        }else {
           addFacility()
        }
    }
    
    @IBAction func saveBarButtonPressed(_ sender: Any) {
        saveGUIToFacility()
    }
}
