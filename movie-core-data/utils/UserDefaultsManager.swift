//
//  UserDefaultsManager.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/12/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    enum Keys : String {
        case SESSION_ID = "session_id"
    }
    
    static func saveSessionId(_ value : String) {
        UserDefaults.standard.set(value, forKey: Keys.SESSION_ID.rawValue)
    }
    
    static func getSessionId() -> String {
        return UserDefaults.standard.string(forKey: Keys.SESSION_ID.rawValue) ?? ""
    }
    
    
}
