//
//  MockNetworkUtils.swift
//  MovieAppUnitTest
//
//  Created by Thet Htun on 5/16/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
import SystemConfiguration
@testable import movie_core_data

class MockNetworkUtils: NetworkUtilsAPI {
    
    var isNetworkReachable = false
    var isOnline = false
    var checkReachability = false
    
    func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        return isNetworkReachable
    }
    
    func isOnline(callback: @escaping (Bool) -> Void) {
        callback(isOnline)
    }
    
    func checkReachable() -> Bool {
        return checkReachability
    }
    
    
}
