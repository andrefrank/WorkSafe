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
}


class TaskCollectionController: UICollectionViewController {

    private let reuseIdentifier = "taskCell"
    
    //Layout of Cells using fixed padding
    //Portrait mode 2 cells per row leads to 3 rows / Landscape mode 3 cells per row leads to 2 rows at all
    var cellsPerRow:CGFloat = 2
    let cellPadding:CGFloat = 1
    
    //Static tasks
    private let selectableTasks=[
        SelectableTask(image: UIImage(named: "compose")!, description: "Issues"),
        SelectableTask(image: UIImage(named: "camera")!, description: "Check"),
        SelectableTask(image: UIImage(named: "printer")!, description: "Assign equipment"),
        SelectableTask(image: UIImage(named: "settings")!, description: "Time tracking"),
        SelectableTask(image: UIImage(named: "printer")!, description: "Information"),
        SelectableTask(image: UIImage(named: "settings")!, description: "Activity report")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
    }
}


//MARK:-CollectionViewDelegateLayout - Cell layout
extension TaskCollectionController:UICollectionViewDelegateFlowLayout{
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
extension TaskCollectionController{
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
        // Configure the cell
        return cell
    }
}


extension TaskCollectionController{
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Row:\(indexPath.row)")
        dismiss(animated: true, completion: nil)
    }
   
}

