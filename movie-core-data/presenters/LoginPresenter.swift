//
//  LoginPresenter.swift
//  movie-core-data
//
//  Created by Thet Htun on 7/25/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation

class LoginPresenter: UserLoginPresenterProtocol {
    var view: UserLoginViewProtocol?
    
    var router: UserLoginRouterProtocol?
    
    var interactor: UserLoginInteractorProtocol?
    
    func signIn(username: String, password: String) {
        interactor?.signIn(username: username, password: password)
    }
    

}
