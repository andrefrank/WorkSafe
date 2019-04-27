//
//  UIViewController+Extension.swift
//  WorkSafe
//
//  Created by Andre Frank on 27.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

extension UIViewController{
    func animateNavigationPrompt(forTime:TimeInterval, withText text:String){
        guard let navigationController = self.navigationController else {fatalError("ViewController doesn't have an UINavigationController")}
        navigationItem.prompt=text

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+forTime) {
            [weak self] in
            self?.navigationItem.prompt=nil
            navigationController.viewIfLoaded?.setNeedsLayout()
            
        }
        
    }

}
