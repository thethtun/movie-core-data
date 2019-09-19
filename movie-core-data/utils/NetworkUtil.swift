//
//  NetworkUtil.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/19/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import Reachability

class NetworkUtils {
    static func isOnline(callback: @escaping (Bool) -> Void){
        //declare this property where it won't go out of scope relative to your listener
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                callback(true)
            } else {
                print("Reachable via Cellular")
                callback(true)
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            callback(false)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
            callback(false)
        }
    }
}
