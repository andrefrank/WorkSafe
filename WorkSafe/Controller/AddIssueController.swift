//
//  AddIssueController.swift
//  WorkSafe
//
//  Created by Andre Frank on 28.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

//MARK:- Wrapper struct Expandable sections
struct ExpandableSection {
    let name: String
    let rowCount: Int
    var isExpanded: Bool
    var shouldExpanded:Bool
}

class AddIssueController: UITableViewController,SegueHandler {
    
    
    //MARK:-@IBOutlets
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var statusPickerView: HorizontalPickerView!
    
    enum SegueIdentifier:String{
        case showObjects="showObjects"
        case showTitles="showIssueTitles"
    }
    
    
    //MARK:- Section properties
    private let sectionHeight:CGFloat=36
    private var sectionContents: [ExpandableSection] = [
        ExpandableSection(name: "Image", rowCount: 1, isExpanded: true,shouldExpanded: true),
        ExpandableSection(name: "Object", rowCount: 1, isExpanded:true, shouldExpanded: false),
        ExpandableSection(name: "Title", rowCount: 1, isExpanded:true, shouldExpanded: false),
        ExpandableSection(name: "Description", rowCount: 1, isExpanded:false, shouldExpanded: false),
        ExpandableSection(name: "Inventory No.", rowCount: 1, isExpanded:true, shouldExpanded: false),
        ExpandableSection(name: "Status", rowCount: 1, isExpanded:false, shouldExpanded: false),
        ExpandableSection(name: "Priority", rowCount: 1, isExpanded:false, shouldExpanded: false),
      //  ExpandableSection(name: "Termination date", rowCount: 1, isExpanded: false, shouldExpanded: true),
      //  ExpandableSection(name: "Responsibility", rowCount: 1, isExpanded: false, shouldExpanded: true)
    ]
    
    //MARK:- Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupGUIElements()

        
    }
    
    func setupGUIElements(){
        //Lets use custom picker
        statusPickerView.delegate=self
        statusPickerView.dataSource=self
        statusPickerView.showGlass=true
        statusPickerView.reloadData()
        
        //Necessary to use the delegate method 'tableView.view(for header, in section)'
        tableView.register(IssueSectionHeader.self, forHeaderFooterViewReuseIdentifier: sectionHeaderIndentifier)
        
        descriptionTextView.layer.cornerRadius=8
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth=0.5
        
    }
}


//MARK: - Custom Picker Delegate & DataSource
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

//MARK:- Table View Delegate & DataSource
extension AddIssueController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionContents.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContents[section].isExpanded ? sectionContents[section].rowCount : 0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeaderIndentifier) as! IssueSectionHeader
        
        view.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height)
        
        view.addTarget(self, action: #selector(handleSectionDetailButtonPressed(_:)), for: .touchUpInside)
        view.sectionName=sectionContents[section].name
        setButtonTitle(forSection: section, initialView: view)
        view.tag = section

        return view
    }
    
    func setButtonTitle(forSection section:Int,initialView:IssueSectionHeader?=nil){
        let collapseTitles=["Show details","Hide details"]
        
        let sectionView = tableView.headerView(forSection: section) as? IssueSectionHeader ?? initialView
    
            if sectionContents[section].isExpanded{
                sectionView!.sectionButtonTitle=collapseTitles[1]
            }else{
                sectionView!.sectionButtonTitle=collapseTitles[0]
            }
    }
    
    
    @objc func handleSectionDetailButtonPressed(_ sender:Any?) {

        let section = (sender as! UIButton).tag
       
        var changeRows = [IndexPath]()
        for index in 0..<sectionContents[section].rowCount {
            changeRows.append(IndexPath(row: index, section: section))
        }

        if sectionContents[section].isExpanded {
            sectionContents[section].isExpanded = false
            //Change button title before deletion due to header cell recycling
            setButtonTitle(forSection: section)
            tableView.deleteRows(at: changeRows, with: .fade)
        } else {
            sectionContents[section].isExpanded = true
            //Change button title before insertion due to header cell dequeing
            setButtonTitle(forSection: section)
            tableView.insertRows(at: changeRows, with: .fade)
           
        }
        
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
}

//MARK:- Navigation
extension AddIssueController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            var title:String=""
        
            let identifier=segueIdentifier(segue: segue)
            switch identifier {
                case .showObjects:
                    title="Show related objects"
                case .showTitles:
                    title="Show Issue Titles"
                
            
            }
            if let vc=segue.destination as? UITableViewController{
                vc.navigationItem.title=title
                vc.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
            }
        
    }
    
    
    
    
}
