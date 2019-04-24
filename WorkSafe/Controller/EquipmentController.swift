//
//  EquipmentController.swift
//  WorkSafe
//
//  Created by Andre Frank on 22.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit
import CoreData


class EquipmentController: UIViewController,SegueHandler {
   
    

    @IBOutlet weak var equipmentTableView: UITableView!
    @IBOutlet weak var issueTableView: UITableView!
    
    enum SegueIdentifier:String{
       case showEquipmentDetail="showEquipmentDetail"
       case addEquipmentDetail="addEquipmentDetail"
       case showIssueDetail="showIssueDetail"
    }
    
    enum CellIdentifier:String{
        case equipmentCell
        case issueCell
    }
    
    var managedObjectContext: NSManagedObjectContext!
    
    private var equipmentDataSource:TableViewDataSource<EquipmentController>!
    private var issueDataSource:TableViewDataSource<EquipmentController>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoreDataTableView()
    }
    
    func setupCoreDataTableView(){
        equipmentTableView.delegate=self
        
        let request = Facility.sortedFetchRequest
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        equipmentDataSource = TableViewDataSource(withTableView:equipmentTableView, cellIdentifier:CellIdentifier.equipmentCell.rawValue, fetchedResultController: frc, delegate: self)
        print(frc)
    }
}





//MARK:-TableViewDataSource
extension EquipmentController:TableViewCoreDataSourceDelegate{
    func configure(cell: EquipmentCell, withObject object: Facility) {
        cell.configure(for: object)
    }
}

//MARK:-TableView Delegate
extension EquipmentController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}


//MARK:- Navigation
extension EquipmentController{
    @IBAction func exitTo(segue:UIStoryboardSegue){
      print("Back from addFacility")
       guard let _=segue.source as? AddFacilityController else {fatalError("Wrong ViewController")}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(segue: segue){
        case .showEquipmentDetail:
            guard let navVC=segue.destination as? UINavigationController, let vc=navVC.viewControllers.first as? AddFacilityController else {fatalError("Wrong ViewController")}
              vc.managedContext=managedObjectContext
            
            guard let indexPath=equipmentTableView.indexPath(for: sender as! UITableViewCell) else {return}
            vc.facilitiy=equipmentDataSource.objectAtIndexPath(indexPath)
            
        case .addEquipmentDetail:
            guard let navVC=segue.destination as? UINavigationController, let vc=navVC.viewControllers.first as? AddFacilityController else {fatalError("Wrong ViewController")}
            
            vc.managedContext=managedObjectContext
        case .showIssueDetail:
            print("")
            
        }
        
    }
}


