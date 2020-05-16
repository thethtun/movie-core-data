//
//  LoadingIndicator.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/12/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import UIKit

class LoadingIndicator {
    
    var refView : UIViewController?

    let activityIndicator : UIActivityIndicatorView = {
        let ui = UIActivityIndicatorView()
        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.style = UIActivityIndicatorView.Style.whiteLarge
        ui.color = UIColor.red
        ui.startAnimating()
        return ui
    }()

    private let TAG = String(describing: LoadingIndicator.self)
    
    init(viewController : UIViewController) {
        self.refView = viewController
        
    }
    
    
    func startLoading() {
        guard let viewcontroller = self.refView else {
            print("\(TAG) : Failed to start Loading")
            return
        }
        
        viewcontroller.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: viewcontroller.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: viewcontroller.view.centerYAnchor, constant: 0).isActive = true
        activityIndicator.startAnimating()
    }
    
    
    func stopLoading() {
        guard let viewcontroller = self.refView else {
            print("\(TAG) : Failed to stop Loading")
            return
        }
        
        activityIndicator.stopAnimating()
        if activityIndicator.isDescendant(of: viewcontroller.view) {
            activityIndicator.removeFromSuperview()
        }
        
    }
    
}
