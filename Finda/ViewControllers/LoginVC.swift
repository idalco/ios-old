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
import SafariServices
import SCLAlertView

class LoginVC: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.FindaColours.White
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        self.emailTextField.setBottomBorderLogin()
        self.passwordTextField.setBottomBorderLogin()
    }
    
    var barStyle = UIStatusBarStyle.lightContent
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return barStyle
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .default
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        if let url = URL(string: "\(domainURL)/user/forgotpasswd") {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true) {}
    }
    
    func setEmailTextFieldBorder(error: Bool = false){
        if (error) {
            self.emailTextField.setBottomBorderLogin(borderColor: UIColor.FindaColours.FindaRed.cgColor)
        } else {
            self.emailTextField.setBottomBorderLogin()
        }
    }
    
    
    func setPasswordTextFieldBorder(error: Bool = false){
        if (error) {
            self.passwordTextField.setBottomBorderLogin(borderColor: UIColor.FindaColours.FindaRed.cgColor)
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
    
    func loginSegue() {
        let modelManager = ModelManager()
        if modelManager.status() == UserStatus.banned {
            LoginManager.signOut()
            return
        
        } else {
            // we can't segue as we need to reset the root controller
            
            guard let window = UIApplication.shared.keyWindow else {
                return
            }

            guard let rootViewController = window.rootViewController else {
                return
            }

            if modelManager.status() != UserStatus.verified && modelManager.status() != UserStatus.special {
                
                let preferences = UserDefaults.standard
                let currentLevel = "verificationSegue"
                let currentLevelKey = "segueIdentifier"
                preferences.set(currentLevel, forKey: currentLevelKey)
                preferences.synchronize()
                
    //                self.performSegue(withIdentifier: "verificationSegue", sender: nil)
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SideMenu")
            vc.view.frame = rootViewController.view.frame
            vc.view.layoutIfNeeded()


            
            UIView.transition(with: window, duration: 0.3, options: [.transitionFlipFromRight, .layoutSubviews], animations: {
                window.rootViewController = vc
            }, completion: { completed in
                // maybe do something here
            })

        }
    }
    
    func login() {
        if(self.emailTextField.text == "") {
            self.setEmailTextFieldBorder(error: true)
            return
        }
        if(self.passwordTextField.text == "") {
            self.setPasswordTextFieldBorder(error: true)
            return
        }
        
        SVProgressHUD.setBackgroundColor(UIColor.FindaColours.LightGrey)
        SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
        SVProgressHUD.show()
        LoginManager.login(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "") { (response, result) in
            SVProgressHUD.dismiss()
            if response {
                self.loginSegue()
            } else {
                if (result["userdata"]["usertype"].intValue == UserType.Client.rawValue) {
                    let alert = UIAlertController(title: "Hi there!", message: "Sorry, currently this app only supports model accounts. Please log in via desktop for now.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                    
                } else {
                    self.setEmailTextFieldBorder(error: true)
                    self.setPasswordTextFieldBorder(error: true)

                    let appearance = SCLAlertView.SCLAppearance()
                    let errorView = SCLAlertView(appearance: appearance)
                    errorView.showError(
                        "Sorry",
                        subTitle: "That username and password combination was not recognised.")

                }
            }
        }
    }
    
    
    @IBAction func login(_ sender: Any) {
        self.login()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let preferences = UserDefaults.standard
        let currentLevel = segue.identifier
        let currentLevelKey = "segueIdentifier"
        preferences.set(currentLevel, forKey: currentLevelKey)
        preferences.synchronize()
        

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

