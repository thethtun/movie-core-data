//
//  LoginViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/12/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var textFieldEmail : UITextField!
    @IBOutlet weak var textFieldPassword : UITextField!
    @IBOutlet weak var buttonSignIn : UIButton!
    
    var loading : LoadingIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sessionId = UserDefaultsManager.sessionId
        if !sessionId.isEmpty {
            displayLoggedInUser()
        }

        initView()
    }
    
    private func initView() {
        loading = LoadingIndicator.init(viewController: self)
        textFieldEmail.attributedPlaceholder =
            NSAttributedString(string: "Enter username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        textFieldPassword.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textFieldPassword.isSecureTextEntry = true
        
        buttonSignIn.layer.cornerRadius = 5
        buttonSignIn.layer.borderWidth = 1
        buttonSignIn.layer.borderColor = UIColor.gray.cgColor
    }
    
    
    @IBAction func onClickSignIn(_ sender : Any) {
        
        
        validateInput { username, password in
            self.loading?.startLoading()
            loginWithID(username, password) { response in
                
                DispatchQueue.main.async { [weak self] in
                    self?.loading?.stopLoading()
                    
                    if let response = response {
                        let sessionId = response.session_id ?? ""
                        UserDefaultsManager.sessionId = sessionId
                        
                        self?.displayLoggedInUser()
                        
                    } else {
                        if let viewcontroller = self {
                            Dialog.showAlert(viewController: viewcontroller, title: "Error :(", message: "Failed to login. Try Again.")
                        }
                        
                    }
                }
            }
        }
    }
    
    
    func displayLoggedInUser() {
        if let userProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController {
            self.navigationController?.setViewControllers([userProfileViewController], animated: true)
        }
    }
    
    func loginWithID(_ username : String,_ password : String, completion: @escaping (CreateSessionResponse?) -> Void) {
        AuthModel.shared.fetchRequestToken { response in
            let requestToken = response?.request_token
            
            var requestBody = [String : String]()
            requestBody["username"] = username
            requestBody["password"] = password
            requestBody["request_token"] = requestToken ?? ""
            
            AuthModel.shared.createSessionWithLogin(body: requestBody) { response in
                if let _ = response {
                    let creatSessionBody = [
                        "request_token" : response?.request_token ?? ""
                    ]
                    
                    AuthModel.shared.createSession(body: creatSessionBody, completion: completion)
                } else {
                    DispatchQueue.main.async {
                        self.loading?.stopLoading()
                        Dialog.showAlert(viewController: self, title: "Hello there...", message: "Either email or password is incorrect")
                    }
                }
            }
        }
    }
    
    func validateInput(success : (String, String) -> Void)  {
        guard let username = textFieldEmail.text, !username.isEmpty else {
            Dialog.showAlert(viewController: self, title: "Attention", message: "Enter Your MovieDB username")
            return
        }
        
        guard let password = textFieldPassword.text, !password.isEmpty else {
            Dialog.showAlert(viewController: self, title: "Attention", message: "Enter MoiveDB Account Password")
            return
        }
        
        success(username, password)
    }
   

}
