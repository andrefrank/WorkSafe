//
//  IssueSectionHeader.swift
//  WorkSafe
//
//  Created by Andre Frank on 28.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

let sectionHeaderIndentifier="sectionHeader"

class IssueSectionHeader: UITableViewHeaderFooterView{
    private var sectionNameLabel: UILabel = {
        let l = UILabel(frame: CGRect.zero)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        return l
    }()
    
    private var sectionDetailButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.contentHorizontalAlignment = .right
        b.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        return b
    }()
    
    @objc func handleSectionButton(){
        sectionDetailButton.sendActions(for: .touchUpInside)
    }
    
    
    private func setupView() {
         let margins = layoutMarginsGuide
        addSubview(sectionNameLabel)
       sectionNameLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10).isActive=true
       sectionNameLabel.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: 0).isActive=true
        
        addSubview(sectionDetailButton)
        sectionDetailButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant:0).isActive=true
        sectionDetailButton.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: 0).isActive=true
        
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
        }
        get{return sectionDetailButton.tag}
    }
    
   
    
    var sectionButtonTitle:String{
        get{
            return sectionDetailButton.titleLabel?.text ?? ""
        }
        set{
            sectionDetailButton.setTitle(newValue, for: .normal)
        }
    }
    
    var sectionName:String{
        get{
            return sectionNameLabel.text ?? ""
        }
        set{
            sectionNameLabel.text=newValue
        }
    }
    
    
    func addTarget(_ target:Any?,action: Selector, for:UIControl.Event){
       sectionDetailButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
}
