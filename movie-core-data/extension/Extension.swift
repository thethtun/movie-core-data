//
//  Extensions.swift
//  contact-core-date
//
//  Created by Thet Htun on 9/26/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import RealmSwift

extension Array {
    func toList<T>() -> List<T>{
        let convertedItems = List<T>()
        
        var index = 0
        while index < count {
            if let data = self[index] as? T {
                convertedItems.append(data)
            }
            index += 1
        }
        
        return convertedItems
    }
}
