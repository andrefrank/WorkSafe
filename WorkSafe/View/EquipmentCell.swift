//
//  EquipmentCell.swift
//  WorkSafe
//
//  Created by Andre Frank on 22.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

class EquipmentCell: UITableViewCell {

    @IBOutlet weak var facilityImageView: UIImageView!
    
    @IBOutlet weak var departmentLabel: UILabel!
    
    @IBOutlet weak var roomNumberLabel: UILabel!
    
    @IBOutlet weak var floorLevelLabel: UILabel!
    
    
    func configure(for facility: Facility) {
       departmentLabel.text=facility.department
       roomNumberLabel.text="Room " + facility.roomNumber
       floorLevelLabel.text="Floor \(facility.floor)"
       
        if let photoURL = facility.photoURL, !photoURL.isEmpty{
            facilityImageView.image = UIImage.loadImageFromUserDirectory(photoURL: photoURL)
        }else{
            facilityImageView.image=UIImage(named: "camera")
        }
    }
}
