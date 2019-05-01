//
//  AddIssueController.swift
//  WorkSafe
//
//  Created by Andre Frank on 28.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

struct ExpandableSection {
    let name: String
    let rowCount: Int
    var isExpanded: Bool
    var shouldExpanded:Bool
}

class AddIssueController: UITableViewController {
    
    
    @IBOutlet weak var statusPickerView: HorizontalPickerView!
    
    //MARK:- Section properties
    private let sectionHeight:CGFloat=36
    
    private var sectionContents: [ExpandableSection] = [
        ExpandableSection(name: "Image", rowCount: 1, isExpanded: true,shouldExpanded: true),
        ExpandableSection(name: "Object", rowCount: 1, isExpanded:true, shouldExpanded: false),
        ExpandableSection(name: "Title", rowCount: 1, isExpanded:true, shouldExpanded: false),
        ExpandableSection(name: "Description", rowCount: 1, isExpanded:true, shouldExpanded: false),
        ExpandableSection(name: "Inventory No.", rowCount: 1, isExpanded:true, shouldExpanded: false),
        ExpandableSection(name: "Status", rowCount: 1, isExpanded:true, shouldExpanded: false),
        ExpandableSection(name: "Priority", rowCount: 1, isExpanded:true, shouldExpanded: false),
      //  ExpandableSection(name: "Termination date", rowCount: 1, isExpanded: false, shouldExpanded: true),
      //  ExpandableSection(name: "Responsibility", rowCount: 1, isExpanded: false, shouldExpanded: true)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statusPickerView.delegate=self
        statusPickerView.dataSource=self
        statusPickerView.showGlass=true
        statusPickerView.reloadData()
    }
}


extension AddIssueController:HorizontalPickerViewDelegate,HorizontalPickerViewDataSource{
    func pickerView_didSelectItem(pickerView: HorizontalPickerView, item: Int) {
        print(item)
    }
    
    func pickerView_willBeginChangeItem(pickerView: HorizontalPickerView) {
        print("Change")
    }
    
    func numberOfItemsInPickerView(horizontalPickerView: HorizontalPickerView) -> Int {
        return 3
    }
    
    func titleforItemInPickerView(horizontalPickerView: HorizontalPickerView, forItem item: Int) -> String {
        
        let statusItems:[String]=["Not started","Started","Completed"]
        return statusItems[item]
        
    }
    
    
    
    
    
}

extension AddIssueController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionContents.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContents[section].isExpanded ? sectionContents[section].rowCount : 0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = IssueSectionHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height:sectionHeight))
       
        view.addTarget(self, action: #selector(handleSectionDetailButtonPressed(_:)), for: .touchUpInside)
        view.configure(sectionName: sectionContents[section].name, detailText: "Show details")
        view.tag = section

        return view
    }

    @objc func handleSectionDetailButtonPressed(_ sender:Any?) {

        let section = (sender as! UIButton).tag
       
        var changeRows = [IndexPath]()
        for index in 0..<sectionContents[section].rowCount {
            changeRows.append(IndexPath(row: index, section: section))
        }

        if sectionContents[section].isExpanded {
            sectionContents[section].isExpanded = false
            tableView.deleteRows(at: changeRows, with: .fade)

        } else {
            sectionContents[section].isExpanded = true
            tableView.insertRows(at: changeRows, with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
}
