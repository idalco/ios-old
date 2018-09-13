//
//  ViewController.swift
//  Finda
//
//  Created by Peter Lloyd on 24/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.FindaColors.White
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        self.emailTextField.setBottomBorderLogin()
        self.passwordTextField.setBottomBorderLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true) {}
    }
    
    func setEmailTextFieldBorder(error: Bool = false){
        if(error){
            self.emailTextField.setBottomBorderLogin(borderColor: UIColor.FindaColors.FindaRed.cgColor)
        } else {
            self.emailTextField.setBottomBorderLogin()
        }
    }
    
    
    func setPasswordTextFieldBorder(error: Bool = false){
        if(error){
            self.passwordTextField.setBottomBorderLogin(borderColor: UIColor.FindaColors.FindaRed.cgColor)
        } else {
            self.passwordTextField.setBottomBorderLogin()
        }
    }
    
    @IBAction func emailTextFieldChange(_ sender: Any) {
        self.setEmailTextFieldBorder()
    }
    
    @IBAction func passwordTextFieldChange(_ sender: Any) {
        self.setPasswordTextFieldBorder()
        
    }
    
    func loginSegue(){
        let modelManager = ModelManager()
        if modelManager.status() == UserStatus.banned {
            LoginManager.signOut()
            return
        } else if modelManager.status() == UserStatus.unverified {
            self.performSegue(withIdentifier: "editProfileSegue", sender: nil)
        } else {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    func login(){
        if(self.emailTextField.text == ""){
            self.setEmailTextFieldBorder(error: true)
            return
        }
        if(self.passwordTextField.text == ""){
            self.setPasswordTextFieldBorder(error: true)
            return
        }
        
        SVProgressHUD.show()
        LoginManager.login(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "") { (response, result) in
            SVProgressHUD.dismiss()
            if response {
                self.loginSegue()
            } else {
                if(result["userdata"]["usertype"].intValue == UserType.Client.rawValue){
                    let alert = UIAlertController(title: "Hello", message: "Currently this app only supports models! Please use the website to edit your client profile.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                    
                } else {
                    self.setEmailTextFieldBorder(error: true)
                    self.setPasswordTextFieldBorder(error: true)
                }
            }
        }
    }
    
    
    @IBAction func login(_ sender: Any) {
        self.login()
        
    }
    
}

extension LoginVC: UITextFieldDelegate {
    // Return goes onto next text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag: NSInteger = textField.tag + 1;
        // Try to find next responder
        if let nextResponder: UIResponder? = textField.superview!.viewWithTag(nextTag){
            if (nextResponder != nil) {
                // Found next responder, so set it.
                nextResponder?.becomeFirstResponder()
            }
        }
        else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            self.login()
        }
        
        return false; // We do not want UITextField to insert line-breaks.
    }
}

