//
//  TaskCollectionController.swift
//  WorkSafe
//
//  Created by Andre Frank on 26.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

struct SelectableTask{
    let image:UIImage
    let description:String
    let type:Task_Type
    
    enum Task_Type{
        case Issue
        case Check
        case Assign
        case Time
        case Information
        case Activity
    }
}


class TaskSelectionController: UICollectionViewController {

    private let reuseIdentifier = "taskCell"
    
    //Layout of Cells using fixed padding
    //Portrait mode 2 cells per row leads to 3 rows / Landscape mode 3 cells per row leads to 2 rows at all
    var cellsPerRow:CGFloat = 2
    let cellPadding:CGFloat = 1
    
    //Static tasks
    private let selectableTasks=[
        SelectableTask(image: UIImage(named: "compose")!, description: "Issues",type: .Issue),
        SelectableTask(image: UIImage(named: "camera")!, description: "Check", type:.Check),
        SelectableTask(image: UIImage(named: "printer")!, description: "Assign equipment",type: .Assign),
        SelectableTask(image: UIImage(named: "settings")!, description: "Time tracking",type: .Time),
        SelectableTask(image: UIImage(named: "printer")!, description: "Information",type: .Information),
        SelectableTask(image: UIImage(named: "settings")!, description: "Activity report",type: .Activity)
    ]
    
    //Mark:Public property
    var dismissHandler:((SelectableTask.Task_Type)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
    }
}


//MARK:-CollectionViewDelegateLayout - Cell layout
extension TaskSelectionController:UICollectionViewDelegateFlowLayout{
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        cellsPerRow = (traitCollection.verticalSizeClass == .compact) ? 3 : 2
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthMinusPadding = UIScreen.main.bounds.width - (cellPadding + cellPadding * cellsPerRow)
        let eachSide = widthMinusPadding / cellsPerRow
        return CGSize(width: eachSide, height: eachSide)
    }
}


  // MARK: UICollectionViewDataSource
extension TaskSelectionController{
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return selectableTasks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TaskCell
        
       cell.configureCell(task: selectableTasks[indexPath.row])
        return cell
    }
}


extension TaskSelectionController{
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let type=selectableTasks[indexPath.row].type
        
            dismiss(animated: true) { [weak self] in
                self?.dismissHandler?(type)
            }
        }
   
}

