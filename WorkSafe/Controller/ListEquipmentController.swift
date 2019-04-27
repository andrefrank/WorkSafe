//
//  EquipmentController.swift
//  WorkSafe
//
//  Created by Andre Frank on 22.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit
import CoreData

let rowHeight:CGFloat=90

class ListEquipmentController: UIViewController,SegueHandler {
   
    
    
    //MARK:-IBOutlets
    @IBOutlet weak var equipmentTableView: UITableView!
    @IBOutlet weak var equipmentsearchBar: UISearchBar!
    
    //MARK: - Segues
    enum SegueIdentifier:String{
       case showEquipmentDetail="showEquipmentDetail"
       case showTaskSelection="showTaskSelection"
    }
    
    //MARK:- Constants
    enum CellIdentifier:String{
        case equipmentCell
        case issueCell
    }
    
    private var lastSelectedIndex:IndexPath?
    
    var searchTask:DispatchWorkItem?
    var managedObjectContext: NSManagedObjectContext!
    var equipmentDataSource:TableViewDataSource<ListEquipmentController>!
    
    
    //MARK:- Life cycle EquipmentController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoreDataTableView()
        equipmentsearchBar.delegate=self
    }
    
    func setupCoreDataTableView(){
        equipmentTableView.delegate=self
        
        let request = Facility.sortedFetchRequest
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        equipmentDataSource = TableViewDataSource(withTableView:equipmentTableView, cellIdentifier:CellIdentifier.equipmentCell.rawValue, fetchedResultController: frc, delegate: self)
    }

}





//MARK:-TableViewDataSource
extension ListEquipmentController:TableViewCoreDataSourceDelegate{
    func configure(cell: EquipmentCell, withObject object: Facility) {
        cell.configure(for: object)
    }
}

//MARK:-TableView Delegate
extension ListEquipmentController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastSelectedIndex=indexPath
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: SegueIdentifier.showTaskSelection.rawValue, sender: self)
        }
    }

}


extension ListEquipmentController{
    //MARK:- Actions
    @IBAction func addNewFacility(_ sender:Any?){
        performSegue(withIdentifier: SegueIdentifier.showEquipmentDetail)
    }
}


//MARK:- Navigation and Segue handling
extension ListEquipmentController{
    @IBAction func exitTo(segue:UIStoryboardSegue){
      print("Back from other Controller")
       //guard let _=segue.source as? AddFacilityController else {fatalError("Wrong ViewController")}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(segue: segue){
        case .showEquipmentDetail:
            guard let navVC=segue.destination as? UINavigationController, let vc=navVC.viewControllers.first as? AddFacilityController else {fatalError("Wrong ViewController")}
              vc.managedContext=managedObjectContext
            //Check if the Segue is triggered from selecting a row in the tableView or if it is triggered from add Bar Button
            if let tableViewCell=sender as? UITableViewCell,let  indexPath=equipmentTableView.indexPath(for: tableViewCell){
                vc.facilitiy=equipmentDataSource.objectAtIndexPath(indexPath)
            }else{
                vc.facilitiy=nil
            }
        case .showTaskSelection:
            guard let vc=segue.destination as? TaskSelectionController else {fatalError("Wrong ViewController")}
            guard let selectIndex=lastSelectedIndex else {fatalError("Wrong index selected")}
            let facility=equipmentDataSource.objectAtIndexPath(selectIndex)
            vc.dismissHandler={  ( type, controller ) in
                switch type{
                case .Check,.Activity,.Assign,.Information,.Time,.Issue:
                    controller?.performSegue(withIdentifier:"showIssueController", sender: facility)
                }
                
            }
            
        }
        
    }
}


