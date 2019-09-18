//
//  BaseModel.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/18/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {}
    
    var persistentContainer : NSPersistentContainer!
    
    var viewContext : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
