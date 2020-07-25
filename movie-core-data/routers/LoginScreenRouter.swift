//
//  LoginScreenRouter.swift
//  movie-core-data
//
//  Created by Thet Htun on 7/25/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
import UIKit

class LoginScreenRouter: UserLoginRouterProtocol {
    static func createVC() -> UINavigationController {
        let navVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: LoginViewController.self)) as! UINavigationController
        let viewController = navVC.viewControllers[0] as! LoginViewController
        
        let presenter = LoginPresenter()
        let interactor = LoginInteractor()
        let router = LoginScreenRouter()
        
        interactor.presenter = presenter
        interactor.userAuthClient = UserAuthClient()
        interactor.networkUtil = NetworkUtils()
        
        presenter.interactor = interactor
        presenter.view = viewController
        presenter.router = router

        viewController.presenter = presenter
        
        return navVC
    }
    
    
}
