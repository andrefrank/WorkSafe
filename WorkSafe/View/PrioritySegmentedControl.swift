//
//  PriorityControl.swift
//  WorkSafe
//
//  Created by Andre Frank on 28.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

@IBDesignable

class PrioritySegmentedControl: UIControl{
    enum Prioritiy:Int{
        case Low
        case Middle
        case High
    }
    
    
    var selectedSegmentIndex=0
    
    @IBInspectable
    var borderWidth:CGFloat=0{
        didSet{
            layer.borderWidth=borderWidth
        }
    }
    
    @IBInspectable
    var borderColor:UIColor = .lightGray{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var commaSeparatedButtonTitles:String=""{
        didSet{
           updateView()
        }
    }
    
    @IBInspectable
    var textColor:UIColor = .lightGray{
        didSet{
            updateView()
        }
        
    }
    
    @IBInspectable
    var selectorColor:UIColor = .darkGray{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var selectorTextColor:UIColor = .white{
        didSet{
            updateView()
        }
    }
    
    private var selectorView:UIView!
    private var buttons=[UIButton]()
    private var selectorColors:[UIColor]=[.green,.orange,.red]
    
    
    private func updateView(){
        buttons.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        
        
        
        let buttonTitles=commaSeparatedButtonTitles.components(separatedBy: ",")
        for title in buttonTitles{
            let button=UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            layer.masksToBounds=true
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        let selectorWidth=frame.width / CGFloat(buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        selectorView.layer.cornerRadius=frame.height/2
        
        selectorView.backgroundColor=selectorColors[selectedSegmentIndex]
        addSubview(selectorView)

        let sv=UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints=false
       
        addSubview(sv)
        sv.topAnchor.constraint(equalTo: topAnchor).isActive=true
        sv.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        sv.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        sv.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        

    }
 
    @objc func buttonTapped(_ sender:UIButton){
        for (buttonIndex,btn) in buttons.enumerated(){
            
             btn.setTitleColor(textColor, for: .normal)
            
            if btn==sender{
                let startPosition=frame.width/CGFloat(buttons.count)*CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x=startPosition
                }
                  btn.setTitleColor(self.selectorTextColor, for: .normal)
                  selectedSegmentIndex = buttonIndex
                  selectorView.backgroundColor=selectorColors[selectedSegmentIndex]
            }
        }
        
        sendActions(for: .valueChanged)
    }
    
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius=frame.height/2
    }
}
