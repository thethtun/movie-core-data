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
        case ACCOUNT_ID = "account_id"
        case USER_NAME = "username"
    }
    
    static func saveSessionId(_ value : String) {
        UserDefaults.standard.set(value, forKey: Keys.SESSION_ID.rawValue)
    }
    
    static func getSessionId() -> String {
        return UserDefaults.standard.string(forKey: Keys.SESSION_ID.rawValue) ?? ""
    }
    
    static func saveAccountId(_ value : String) {
        UserDefaults.standard.set(value, forKey: Keys.ACCOUNT_ID.rawValue)
    }
    
    static func getAccountId() -> String {
        return UserDefaults.standard.string(forKey: Keys.ACCOUNT_ID.rawValue) ?? ""
    }
    
    static func saveUsername(_ value : String) {
        UserDefaults.standard.set(value, forKey: Keys.USER_NAME.rawValue)
    }
    
    static func getUsername() -> String {
        return UserDefaults.standard.string(forKey: Keys.USER_NAME.rawValue) ?? ""
    }
    
    static func clearAll() {
        UserDefaults.standard.set("", forKey: Keys.SESSION_ID.rawValue)
        UserDefaults.standard.set("", forKey: Keys.ACCOUNT_ID.rawValue)
    }
    
}
