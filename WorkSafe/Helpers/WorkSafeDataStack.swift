//
//  WorkSafeDataStack.swift
//  WorkSafe
//
//  Created by Andre Frank on 22.04.19.
//  Copyright © 2019 Afapps+. All rights reserved.
//

import CoreData

func createWorkSafeContainer(completion: @escaping (NSPersistentContainer) -> ()) {
    let container = NSPersistentContainer(name: "WorkSafe")
    container.loadPersistentStores { _, error in
        guard error == nil else { fatalError("Failed to load store: \(error!)") }
        DispatchQueue.main.async { completion(container) }
    }
}
