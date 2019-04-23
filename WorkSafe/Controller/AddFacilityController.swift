//
//  AddFacilityController.swift
//  WorkSafe
//
//  Created by Andre Frank on 22.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import CoreData
import UIKit

class AddFacilityController: UITableViewController,CapturePhotoServiceDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet var departmentTextField: UITextField!
    
    @IBOutlet var floorLevelTextField: UITextField!
    @IBOutlet var roomNumberTextField: UITextField!
    @IBOutlet var facilityImageView: UIImageView!
    
    // MARK: - Public properties
    
    var facilitiy: Facility?
    var managedContext: NSManagedObjectContext!
    
    //MARK:-Private properties
    var capturePhotoService:CapturePhotoService?
    
    typealias ActionSheetSelectionHandler = (UIAlertAction) -> Void
    
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
            let capturePhoto=CapturePhotoService(delegate: self, withType:.PhotoLibrary)
            self.capturePhotoService=capturePhoto
            self.capturePhotoService?.captureImage()
        }) { _ in
             let capturePhoto=CapturePhotoService(delegate: self, withType:.Camera)
            self.capturePhotoService=capturePhoto
            self.capturePhotoService?.captureImage()
        }
    }
    
    func capturePhotoDidCapture(_ image: UIImage?) {
        facilityImageView.image=image
    }
    
    func capturePhotoDidChangeAuthorizationStatus(authorized: Bool) {
        print(authorized)
    }
    
    
    func showImageSourceSelectionSheet(selectionPhotoLibrary: @escaping ActionSheetSelectionHandler, selectionCamera: @escaping ActionSheetSelectionHandler) {
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
    }
    
    private func saveGUIToFacility() {
        if let fac = self.facilitiy {
            managedContext.performChanges { [unowned self] in
                fac.department = self.departmentTextField.text ?? "Department"
                fac.floor = Int16(self.floorLevelTextField.text ?? "0")!
                fac.roomNumber = self.roomNumberTextField.text ?? ""
            }
        } else {
            managedContext.performChanges { [weak self] in
                guard let mySelf = self else { return }
                _ = Facility.insert(into: mySelf.managedContext, department: "Production", photoURL: "test.jpg", roomNumber: "1.028", floor: 0)
            }
        }
    }
    
    @IBAction func saveBarButtonPressed(_ sender: Any) {
        saveGUIToFacility()
    }
}
