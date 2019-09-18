//
//  WidgetGenerator.swift
//  contact-core-date
//
//  Created by Thet Htun on 9/14/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import UIKit

class WidgetGenerator {

    static func getUILabelMovieInfo(_ text : String = "") -> UILabel {
        let ui = UILabel()
        ui.font = UIFont.systemFont(ofSize: 15)
        ui.numberOfLines = 0
        ui.text = text
        ui.textColor = Theme.primaryTextColor
        return ui
    }
    
    static func getUILabelTitle(_ title : String = "title") -> UILabel {
        let ui = UILabel()
        ui.font = UIFont.boldSystemFont(ofSize: 20)
        ui.text = title
        ui.textColor = Theme.primaryTextColor
        return ui
    }
}
