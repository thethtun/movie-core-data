//
//  LoginInteractor.swift
//  movie-core-data
//
//  Created by Thet Htun on 7/25/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation

class LoginInteractor: UserLoginInteractorProtocol {
    
    var presenter : UserLoginPresenterProtocol?
    var userAuthClient : UserAuthAPI?
    var networkUtil : NetworkUtilsAPI?
    
    func signIn(username: String, password: String) {
        self.presenter?.view?.showLoading()
        if networkUtil?.checkReachable() == false {
            self.presenter?.view?.stopLoading()
            self.presenter?.view?.showError(msg: "No internet connection!")
        } else {
            userAuthClient?.fetchRequestToken { response in
                let requestToken = response?.request_token
                
                var requestBody = [String : String]()
                requestBody["username"] = username
                requestBody["password"] = password
                requestBody["request_token"] = requestToken ?? ""
                
                self.userAuthClient?.createSessionWithLogin(body: requestBody) { response in
                    DispatchQueue.main.async { [weak self] in
                        if let _ = response {
                            let creatSessionBody = [
                                "request_token" : response?.request_token ?? ""
                            ]
                            
                            self?.userAuthClient?.createSession(body: creatSessionBody) { data in
                                self?.presenter?.view?.stopLoading()
                                self?.presenter?.view?.onLogginSuccess(data: data)
                            }
                        } else {
                            self?.presenter?.view?.stopLoading()
                            self?.presenter?.view?.showError(msg: "Either email or password is incorrect")
                        }
                    }
                }
            }
        }
        
    }
    
}
