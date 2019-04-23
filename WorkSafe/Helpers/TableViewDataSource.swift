//
//  TableViewDataSource.swift
//  WorkSafe
//
//  Created by Andre Frank on 22.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit
import CoreData


protocol TableViewCoreDataSourceDelegate:class {
    associatedtype Object:NSFetchRequestResult
    associatedtype Cell:UITableViewCell
    func configure(cell:Cell,withObject object:Object)
}

class TableViewDataSource<Delegate:TableViewCoreDataSourceDelegate>:NSObject,UITableViewDataSource,NSFetchedResultsControllerDelegate{
    typealias Object = Delegate.Object
    typealias Cell = Delegate.Cell
    
    
    required init(withTableView tableView:UITableView, cellIdentifier:String,fetchedResultController:NSFetchedResultsController<Object>,delegate:Delegate ){
        
        self.tableView=tableView
        self.cellIdentifier=cellIdentifier
        self.delegate=delegate
        self.fetchedResultController=fetchedResultController
        
        super.init()
        
        fetchedResultController.delegate=self
        try! fetchedResultController.performFetch()
        self.tableView.dataSource=self
        self.tableView.reloadData()
    }
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object {
        return fetchedResultController.object(at: indexPath)
    }
  
    var selectedObject:Object?{
        
        guard let index = tableView.indexPathForSelectedRow else {return nil}
        return objectAtIndexPath(index)
        
    }
    
    
    private let tableView:UITableView
    private let cellIdentifier:String
    private weak var delegate:Delegate?
    fileprivate let fetchedResultController:NSFetchedResultsController<Object>
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! Cell
    
        delegate?.configure(cell: cell, withObject: fetchedResultController.object(at: indexPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let object=objectAtIndexPath(indexPath) as? NSManagedObject {
                object.managedObjectContext?.performChanges(block: {
                    object.managedObjectContext?.delete(object)
                })
            }
        }
    }
    
    //MARK:- NSFetchedResultsControllerDeleagte

    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError("Index path should be not nil") }
            tableView.insertRows(at: [indexPath], with: .fade)
            print("Added")
        case .delete:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("Deleted")
        case .update:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            let object = objectAtIndexPath(indexPath)
            guard let cell = tableView.cellForRow(at: indexPath) as? Cell else { break }
            delegate?.configure(cell: cell, withObject: object)
        case .move:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            guard let newIndexPath = newIndexPath else { fatalError("New index path should be not nil") }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.insertRows(at: [newIndexPath], with: .fade)
            
        @unknown default:
            fatalError("Unknown ")
        }
        
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
}

