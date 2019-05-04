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
    
    
    var lastDay:Int=31{
        didSet{
            datePickerView.reloadAllComponents()
        }
    }
    
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
        lastDay=PickerDate.lastDayOfMonthBy(date: Date())
        datePickerView.reloadAllComponents()
        setDatePickerComponentsBy(date: Date())
        
        
        objectTextField.delegate=self
        issueTitleTextField.delegate=self
        
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(dismissKeyboardOnGesture(gesture:))))
        
        
        let flowLayout=UICollectionViewFlowLayout()
       flowLayout.scrollDirection = .horizontal
        pictureCollectionView.collectionViewLayout=flowLayout
        pictureCollectionView.delegate=self
        pictureCollectionView.dataSource=self
        
        
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


enum DateSection:Int,CaseIterable{
    case Day=0
    case Month=1
    case Year=2
    
    static func sectionForComponent(component:Int)->DateSection{
        guard let pickerSection=DateSection(rawValue: component) else {fatalError("Wrong component value")}
        return pickerSection
    }
}

struct PickerDate{
    typealias DateComponent = (day:Int,month:Int,year:Int)
    
    static let months=["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    static func yearsFromNow(inFuture distance:Int)->Int{
        let currentDate=Date()
        let calendar=Calendar.current
        //Extract each component
        let year=calendar.component(.year, from: currentDate)
        return year+distance
    }
    
    static func lastDayOfMonthByComponents(month:Int, byYear year:Int)->Int{
        let components=DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: nil, year: year, month: month, day: 1, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)

        let date = Calendar.current.date(from: components)
        let interval = Calendar.current.dateInterval(of: .day, for:date!)
        
        let calendar=Calendar.current
        let range=calendar.range(of: .day, in: .month, for: date!)
        
        return range!.upperBound-1
    }
    
    static func lastDayOfMonthBy(date:Date)->Int{
        let month=Calendar.current.component(.month, from: date)
        let year=Calendar.current.component(.year, from: date)
        
        return self.lastDayOfMonthByComponents(month: month, byYear: year)
    }
    
    static func currentDateComponents()->DateComponent{
        let currentDate=Date()
        let calendar=Calendar.current
        //Extract each component
        let year=calendar.component(.year, from: currentDate)
        let month=calendar.component(.month, from: currentDate)
        let day=calendar.component(.day, from: currentDate)
        
        return (day,month:month,year:year)

    }
}

//MARK:- Custom Date Picker
extension AddIssueController:UIPickerViewDelegate,UIPickerViewDataSource{
    func setDatePickerComponentsBy(date:Date){
        let dateComponents=PickerDate.currentDateComponents()
        
        datePickerView.selectRow(dateComponents.day-1, inComponent:DateSection.Day.rawValue, animated: false)
        datePickerView.selectRow(dateComponents.month-1, inComponent:DateSection.Month.rawValue, animated: false)
        datePickerView.selectRow(dateComponents.year, inComponent:DateSection.Year.rawValue, animated: false)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch DateSection.sectionForComponent(component: component) {
        case .Day:
            return lastDay  //Calculated maximum days per month
        case .Month:
            return 12 //maximum monthes per year
        case .Year:
            return 20// Display 20 years further from now
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return DateSection.allCases.count
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let month=pickerView.selectedRow(inComponent: 1)+1
        let year=pickerView.selectedRow(inComponent: 2)+2019
        
        lastDay=PickerDate.lastDayOfMonthByComponents(month: month, byYear: year)
        
    }
    
    
   
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        //Split each date component
        let x=pickerView.frame.width*CGFloat(component)
        let labelWidth=pickerView.frame.width / CGFloat(3)
        let y=pickerView.frame.height/2 - CGFloat(25)/CGFloat(2)
        let Label=UILabel(frame: CGRect(x:x, y: y, width: labelWidth, height: 25))
        Label.textAlignment = .center
        
        switch DateSection.sectionForComponent(component: component){
        case .Day:
            Label.text="\(row+1)"
        case .Month:
            Label.text="\(PickerDate.months[row])"
        case .Year:
            Label.text="\(PickerDate.yearsFromNow(inFuture: row))"
        }
        
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
        
        showActionButton(forSection: section, initialView: view)
        
        //button touched handling
        view.delegate=self
        
        view.configureIssueHeader(withTag: section,sectionTitle:sectionContents[section].name,  actionButtonTitle:sectionContents[section].sectionButtonTitle , actionButtonImage:sectionContents[section].sectionButtonImage)
        
       
        return view
    }
    
    func showActionButton(forSection section:Int,initialView:IssueSectionHeader?=nil,show:Bool=true){
        
        let sectionView = tableView.headerView(forSection: section) as? IssueSectionHeader ?? initialView

        sectionView?.actionButton.isHidden = !show
        
    }
    
    func leftActionItemTouched(section: Int) {
        var changeRows = [IndexPath]()
        for index in 0..<sectionContents[section].rowCount {
            changeRows.append(IndexPath(row: index, section: section))
        }
        
        if sectionContents[section].isExpanded {
            sectionContents[section].isExpanded = false
            //Change button title before deletion due to header cell recycling
           // showActionButton(forSection: section, show: false)
            
            tableView.deleteRows(at: changeRows, with: .fade)
        } else {
            sectionContents[section].isExpanded = true
            //Change button title before insertion due to header cell dequeing
           // showActionButton(forSection: section, show: false)
            
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

extension AddIssueController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}


extension AddIssueController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    
    
    
    
}
