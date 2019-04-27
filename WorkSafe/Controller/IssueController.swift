//
//  IssueController.swift
//  WorkSafe
//
//  Created by Andre Frank on 27.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

class IssueController: UIViewController {

    //MARK:-IBOutlets
    
    @IBOutlet weak var facilityImageView: UIImageView!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var userDefinedNameLabel: UILabel!
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var floorLevelLabel: UILabel!
    
    
    var facility:Facility!
        
    func loadFacilityToGUI(){
        departmentLabel.text=facility.department
        userDefinedNameLabel.text=facility.userDefinedName
        roomNumberLabel.text="Room "+facility.roomNumber
        floorLevelLabel.text="Floor "+"\(facility.floor)"
        
        if let photoURL = facility.photoURL,!photoURL.isEmpty {
            facilityImageView.image = UIImage.loadImageFromUserDirectory(photoURL: photoURL)
        } else {
            facilityImageView.image = UIImage(named: "camera")
        }

    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFacilityToGUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateNavigationPrompt(forTime: 2.0, withText: "Create an issue report")
    }
    
    
   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
