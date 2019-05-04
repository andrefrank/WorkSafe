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
    var sectionButtonImage:UIImage?
    var sectionButtonTitle:String?
    
}

class AddIssueController: UITableViewController,SegueHandler {
    
    
    //MARK:-@IBOutlets
    
    @IBOutlet weak var issueTitleTextField: UITextField!
    @IBOutlet weak var objectTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var statusPickerView: HorizontalPickerView!
    @IBOutlet weak var datePickerView: UIPickerView!
    
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    //Segue handler protocol
    enum SegueIdentifier:String{
        case showObjects="showObjects"
        case showTitles="showIssueTitles"
    }
    
    
    //MARK:- Section properties
    private let sectionHeaderHeight:CGFloat=48
    
    
    private var sectionContents: [ExpandableSection] = [
        ExpandableSection(name: "Image", rowCount: 1, isExpanded: true,shouldExpanded: true,sectionButtonImage:UIImage(named: "camera"),sectionButtonTitle:nil),
        
        ExpandableSection(name: "Object", rowCount: 1, isExpanded:true, shouldExpanded: false,sectionButtonImage:UIImage(named: "arrow_right"),sectionButtonTitle:nil),
        
        ExpandableSection(name: "Title", rowCount: 1, isExpanded:true, shouldExpanded: false,sectionButtonImage: UIImage(named: "images"),sectionButtonTitle: nil),
            
        ExpandableSection(name: "Description", rowCount: 1, isExpanded:false, shouldExpanded: false, sectionButtonImage:UIImage(named: "microphone"),sectionButtonTitle:nil),
        
        ExpandableSection(name: "Inventory No.", rowCount:1, isExpanded:true, shouldExpanded: false,sectionButtonImage:UIImage(named: "camera"),sectionButtonTitle:nil),
        
        ExpandableSection(name: "Status", rowCount: 1, isExpanded:false, shouldExpanded: false,sectionButtonImage: nil,sectionButtonTitle: nil),
        
        ExpandableSection(name: "Priority", rowCount: 1, isExpanded:false, shouldExpanded: false,sectionButtonImage: nil,sectionButtonTitle: nil),
        
      ExpandableSection(name: "Deadline", rowCount: 1, isExpanded: false, shouldExpanded: true,sectionButtonImage: nil,sectionButtonTitle: nil)
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
        
        datePickerView.delegate=self
        datePickerView.dataSource=self
        
        
        objectTextField.delegate=self
        issueTitleTextField.delegate=self
        
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(dismissKeyboardOnGesture(gesture:))))
        
    }
    
    @objc func dismissKeyboardOnGesture(gesture:UITapGestureRecognizer){
        descriptionTextView.endEditing(true)
        objectTextField.endEditing(true)
        issueTitleTextField.endEditing(true)
    }

}

extension AddIssueController:UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}


enum PickerSection:Int,CaseIterable{
    case Day=0
    case Month=1
    case Year=2
    
    static func sectionForComponent(component:Int)->PickerSection{
        guard let pickerSection=PickerSection(rawValue: component) else {fatalError("Wrong component value")}
        return pickerSection
    }
}

struct PickerDate{
    static func yearFromNow(inFuture distance:Int)->Int{
        let currentDate=Date()
        let calendar=Calendar.current
        //Extract each component
        let year=calendar.component(.year, from: currentDate)
        return year
    }
    
    static func lastDay(ofMonth month:Int, byYear year:Int)->Date?{
        let interval = Calendar.current.dateInterval(of: .month, for:Date())
         return interval?.end
    }
}

//MARK:- Custom Date Picker
extension AddIssueController:UIPickerViewDelegate,UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch PickerSection.sectionForComponent(component: component) {
        case .Day:
            return 31
        case .Month:
            return 12
        case .Year:
            return PickerDate.yearFromNow(inFuture: 20)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PickerSection.allCases.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch PickerSection.sectionForComponent(component: component) {
        case .Day:
            return
        case .Month:
            pickerView.reloadComponent(0)
        case .Year:
            pickerView.reloadComponent(0)
        }
        
    }
    
    
   
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let x=pickerView.frame.width*CGFloat(component)
        let labelWidth=pickerView.frame.width / CGFloat(3)
        let y=pickerView.frame.height/2 - CGFloat(25)/CGFloat(2)
        let Label=UILabel(frame: CGRect(x:x, y: y, width: labelWidth, height: 25))
        
        Label.text="Test"
        return Label
    
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

extension AddIssueController:IssueSectionHeaderActionItemDelegate{
    
    //MARK:-Header for Section Delegate methods
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeaderIndentifier) as! IssueSectionHeader
        
        showActionButton(forSection: section, initialView: view,show:sectionContents[section].isExpanded)
        
        //button touched handling
        view.delegate=self
        
        view.configureIssueHeader(withTag: section,sectionTitle:sectionContents[section].name,  actionButtonTitle:sectionContents[section].sectionButtonTitle , actionButtonImage:sectionContents[section].sectionButtonImage)
        
       
        return view
    }
    
    func showActionButton(forSection section:Int,initialView:IssueSectionHeader?=nil,show:Bool){
        
        let sectionView = tableView.headerView(forSection: section) as? IssueSectionHeader ?? initialView
        
        if sectionContents[section].isExpanded{
            sectionView?.actionButton.isHidden=false
        }else{
            sectionView?.actionButton.isHidden=true
        }
    }
    
    func leftActionItemTouched(section: Int) {
        var changeRows = [IndexPath]()
        for index in 0..<sectionContents[section].rowCount {
            changeRows.append(IndexPath(row: index, section: section))
        }
        
        if sectionContents[section].isExpanded {
            sectionContents[section].isExpanded = false
            //Change button title before deletion due to header cell recycling
            showActionButton(forSection: section, show: false)
            
            tableView.deleteRows(at: changeRows, with: .fade)
        } else {
            sectionContents[section].isExpanded = true
            //Change button title before insertion due to header cell dequeing
            showActionButton(forSection: section, show: false)
            
            tableView.insertRows(at: changeRows, with: .fade)
            
        }
    }
    
    func rightActionItemTouchedIn(section: Int) {
        print(section)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
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
