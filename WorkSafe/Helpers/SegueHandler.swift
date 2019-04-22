//
//  SegueHandler.swift
//  WorkSafe
//
//  Created by Andre Frank on 22.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

protocol SegueHandler {
    associatedtype SegueIdentifier:RawRepresentable
}


extension SegueHandler where Self:UIViewController,SegueIdentifier.RawValue==String{
    
    func segueIdentifier(segue:UIStoryboardSegue)->SegueIdentifier{
        //Check if identifier is present
        guard let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier) else {fatalError("Unknown segue:\(segue)")}
        
        return segueIdentifier
    }
    
    func performSegue(withIdentifier ientifier:SegueIdentifier, sender:Any?=nil){
        performSegue(withIdentifier: ientifier.rawValue, sender:sender)
    }
    
    
}
