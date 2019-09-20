//
//  DialogUtil.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/19/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import UIKit


class Dialog {
    static func showAlert(viewController : UIViewController, title : String, message : String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alertVC, animated: true, completion: nil)
    }
}
