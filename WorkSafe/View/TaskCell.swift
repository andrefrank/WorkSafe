//
//  TaskCell.swift
//  WorkSafe
//
//  Created by Andre Frank on 26.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

class TaskCell: UICollectionViewCell {
    
    
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskImageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    func configureCell(task:SelectableTask){
        taskImageView.image=task.image
        taskDescriptionLabel.text=task.description
        backgroundColor=UIColor.white.withAlphaComponent(0.5)
    }


}


