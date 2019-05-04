//
//  IssueSectionHeader.swift
//  WorkSafe
//
//  Created by Andre Frank on 28.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

let sectionHeaderIndentifier="sectionHeader"

protocol IssueSectionHeaderActionItemDelegate:class {
    func leftActionItemTouched(section:Int)
    func rightActionItemTouchedIn(section:Int)
}

class IssueSectionHeader: UITableViewHeaderFooterView{
    
    weak var delegate:IssueSectionHeaderActionItemDelegate?
    
    private var sectionDetailButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.contentHorizontalAlignment = .center
        b.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
        b.addTarget(self, action: #selector(handleLeftItemButton(_:)), for: .touchUpInside)
        return b
    }()
    
    private var sectionActionButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.contentHorizontalAlignment = .center
        b.addTarget(self, action: #selector(handleRightItemButton(_:)), for: .touchUpInside)
        b.contentMode = .center
        b.imageView?.contentMode = .scaleAspectFill
        //b.backgroundColor=UIColor.red
        b.titleLabel?.textAlignment = .center
         b.contentEdgeInsets=UIEdgeInsets(top: 5, left:5, bottom: 5, right: 5)
        return b
    }()
    

    private func setupView() {
         let margins=self.layoutMarginsGuide
        
        addSubview(sectionDetailButton)
        sectionDetailButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant:10).isActive=true
        sectionDetailButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive=true
        
        addSubview(sectionActionButton)
        sectionActionButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant:0).isActive=true
        sectionActionButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive=true
        
    }
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //Expose button tags
    override var tag:Int{
        set{
            sectionDetailButton.tag=newValue
            sectionActionButton.tag=newValue
        }
        get{return sectionDetailButton.tag}
    }
    
    var actionButton:UIButton{
        return sectionActionButton
    }
    
    var sectionButtonTitle:String{
        get{
            return sectionDetailButton.titleLabel?.text ?? ""
        }
        set{
            sectionDetailButton.setTitle(newValue, for: .normal)
        }
    }
    
    func configureIssueHeader(withTag tag:Int,sectionTitle:String,actionButtonTitle:String?,actionButtonImage:UIImage?){
        
        self.tag=tag
        sectionButtonTitle=sectionTitle
        actionButton.setTitle(actionButtonTitle, for: .normal)
        actionButton.titleLabel?.textAlignment = .center
        actionButton.setImage(actionButtonImage, for: .normal)
    }
    
    
    @objc func handleLeftItemButton(_ sender: UIButton){
        delegate?.leftActionItemTouched(section: sender.tag)
    }
    
    @objc func handleRightItemButton(_ sender: UIButton){
        delegate?.rightActionItemTouchedIn(section: sender.tag)
    }
    
}
