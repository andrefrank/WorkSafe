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
    
    @IBOutlet weak var userDefinedNameTextField: UITextField!
    // MARK: - Public properties
    
    var facilitiy: Facility?
    var managedContext: NSManagedObjectContext!
    var imageCompletionHandler: ((UIImage) -> Void)?
    
    typealias ActionSheetHandler = (UIAlertAction) -> Void
    
    // MARK: -Private properties
    private var capturePhotoService: CapturePhotoService?
    
    private var facilityImage:UIImage?{
        didSet{
            facilityImageView.image = facilityImage
            imageHasChanged=true
        }
    }
    
    private var imageHasChanged:Bool=false
    
    // MARK: - Life cycle of the AddFacilityController
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFacilityDataToGUI()
        setupGesture()
        
        // Used for dismissing the keyboard after editing
        departmentTextField.delegate = self
        floorLevelTextField.delegate = self
        roomNumberTextField.delegate = self
        userDefinedNameTextField.delegate = self
        
        
        
    }
    
    
    
    //MARK: - Gesture Recognizer and Handling
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
    
    //MARK:- Photo Capture
    func capturePhotoDidCapture(_ image: UIImage?) {
        facilityImage=image
    }
    
    func capturePhotoDidChangeAuthorizationStatus(authorized: Bool, forType type: CapturePhotoService.CaptureType) {
        if type == .Camera {
            print("Access has changed for camera")
        } else {
            print("Acces has changed for Photo Library")
        }
    }
    
    //MARK:- Input and output data
    private func loadFacilityDataToGUI() {
        guard let fac = facilitiy else { return }
        roomNumberTextField.text = fac.roomNumber
        departmentTextField.text = fac.department
        floorLevelTextField.text = "\(fac.floor)"
        userDefinedNameTextField.text = fac.userDefinedName
        
        if let photoURL = fac.photoURL,!photoURL.isEmpty {
            facilityImageView.image = UIImage.loadImageFromUserDirectory(photoURL: photoURL)
        } else {
            facilityImageView.image = UIImage(named: "camera")
        }
    }
    
    private func saveGUIToFacility() {
        if let fac = self.facilitiy {
            changeFacility(fac: fac)
        } else {
            addFacility()
        }
    }
    
    
    private func changeFacility(fac: Facility) {
        managedContext.performChanges { [unowned self] in
            fac.department = self.departmentTextField.text ?? "Department"
            fac.floor = Int16(self.floorLevelTextField.text ?? "0")!
            fac.roomNumber = self.roomNumberTextField.text ?? ""
            fac.userDefinedName = self.userDefinedNameTextField.text ?? ""
            
            // Only save a new image if the user has an image selected and the department is valid
            guard let image = self.facilityImageView.image, let department = self.departmentTextField.text else { return }
            
            //Replace image
            if let photoURL = fac.photoURL {
                print(NSHomeDirectory())
                _ = FileManager.default.deleteFileInUserDirectory(fileName: photoURL)
            }
            
            fac.photoURL = image.saveToUserDirectory(pathComponent: department, filename: "Test.jpg")
            
        }
    }
    
    private func addFacility() {
        managedContext.performChanges { [weak self] in
            
            // Only save a new image if the user has an image selected and the department is valid
            var photoURL: String?
            
            if let image = self?.facilityImageView.image, let department = self?.departmentTextField.text {
                photoURL = image.saveToUserDirectory(pathComponent: department, filename: "Test.jpg")
            }
            
            guard let mySelf = self else { return }
            _ = Facility.insert(into: mySelf.managedContext, department: self?.departmentTextField.text ?? "Department", photoURL: photoURL, roomNumber: self?.roomNumberTextField.text ?? "", floor: Int16(self?.floorLevelTextField.text ?? "0")!,userDefinedName:self?.userDefinedNameTextField.text ?? "")
        }
    }
    
    
    //MARK:- Actions
    @IBAction func saveBarButtonPressed(_ sender: Any) {
        saveGUIToFacility()
    }
}



//MARK: - TextField Delegate & Responder handling
extension AddFacilityController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let innerStackView = textField.superview,
            let outerStackView = innerStackView.superview,
            let nextTextField = outerStackView.viewWithTag(textField.tag + 1) {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
}
