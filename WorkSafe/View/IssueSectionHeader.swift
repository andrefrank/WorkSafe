//
//  IssueSectionHeader.swift
//  WorkSafe
//
//  Created by Andre Frank on 28.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

class IssueSectionHeader: UIView{
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //Expose buttons tag
    override var tag:Int{
        set{
            sectionDetailButton.tag=newValue
        }
        get{return sectionDetailButton.tag}
    }
    
    func configure(sectionName:String,detailText:String){
        sectionDetailButton.setTitle(detailText, for: .normal)
        sectionNameLabel.text=sectionName
    }
    
    func addTarget(_ target:Any?,action: Selector, for:UIControl.Event){
       sectionDetailButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
}
