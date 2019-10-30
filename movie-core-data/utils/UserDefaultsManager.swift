//
//  UserDefaultsManager.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/12/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation

struct UserDefaultsManager {

    enum Keys : String {
        case SESSION_ID = "session_id"
        case ACCOUNT_ID = "account_id"
        case USER_NAME = "username"
    }

    @UserDefault(Keys.SESSION_ID.rawValue, defaultValue: "")
    static var sessionId : String

    @UserDefault(Keys.ACCOUNT_ID.rawValue, defaultValue: "")
    static var accountId : String
    
    @UserDefault(Keys.USER_NAME.rawValue, defaultValue: "")
    static var username : String
    
    static func clearAll() {
        self.sessionId = ""
        self.accountId = ""
        self.username = ""
    }
    
}


@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
