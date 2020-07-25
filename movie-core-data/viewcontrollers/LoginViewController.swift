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
    
    var presenter : UserLoginPresenterProtocol?
    
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
            self.presenter?.signIn(username: username, password: password)
        }
    }
    
    
    func displayLoggedInUser() {
        if let userProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: UserProfileViewController.self)) as? UserProfileViewController {
            self.navigationController?.setViewControllers([userProfileViewController], animated: true)
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

extension LoginViewController: UserLoginViewProtocol {
    func onLogginSuccess(data: CreateSessionResponse?) {
        if let response = data {
            let sessionId = response.session_id ?? ""
            UserDefaultsManager.sessionId = sessionId
            
            self.displayLoggedInUser()
            
        } else {
            Dialog.showAlert(viewController: self, title: "Error :(", message: "Failed to login. Try Again.")
        }
    }
    
    
    func showError(msg: String) {
        Dialog.showAlert(viewController: self, title: "Oops...", message: msg)
    }
    
    func showLoading() {
        self.loading?.startLoading()
    }
    
    func stopLoading() {
        self.loading?.stopLoading()
    }
    
    
}
