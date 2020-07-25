//
//  UserLoginProtocols.swift
//  movie-core-data
//
//  Created by Thet Htun on 7/25/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
import UIKit

protocol UserLoginInteractorProtocol {
    func signIn(username : String,password : String)
}

protocol UserLoginPresenterProtocol {
    var view : UserLoginViewProtocol? { get set }
    var router : UserLoginRouterProtocol? { get set }
    var interactor : UserLoginInteractorProtocol? { get set }
    func signIn(username : String,password : String)
}

protocol UserLoginViewProtocol {
    func showError(msg : String)
    func showLoading()
    func stopLoading()
    func onLogginSuccess(data : CreateSessionResponse?)
}

protocol UserLoginRouterProtocol {
    static func createVC() -> UINavigationController
}
