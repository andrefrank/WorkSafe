//
//  EquipmentController+SearchBarDelegate.swift
//  WorkSafe
//
//  Created by Andre Frank on 26.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import UIKit

extension EquipmentController:UISearchBarDelegate{
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       print(searchBar.text)
      searchBar.resignFirstResponder()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Did begin editing")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("SearchBar button clicked")
        searchBar.resignFirstResponder()
    }
    


    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Bookmark button pressed")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Change")
    }
    
    
    
}
