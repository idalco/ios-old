//
//  ViewController.swift
//  Finda
//
//  Created by Peter Lloyd on 24/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var findaImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.FindaColors.White
        
        let theImage = self.findaImageView.image
        
        
        let filter = CIFilter(name: "CIColorInvert")
        
        filter?.setValue(CIImage(image: theImage!), forKey: kCIInputImageKey)
        
        

        
        self.findaImageView.contentMode = .scaleAspectFill
        //self.findaImageView.image = UIImage(ciImage: (filter?.outputImage)!, scale: 1.0, orientation: UIImageOrientation.up)
        
        
        self.emailTextField.setBottomBorderLogin()
        self.passwordTextField.setBottomBorderLogin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func login(){
        if(self.emailTextField.text == ""){
            self.setEmailTextFieldBorder(error: true)
            return
        }
        if(self.passwordTextField.text == ""){
            self.setPasswordTextFieldBorder(error: true)
            return
        }
        
        let loginManager = LoginManager()
        loginManager.login(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "") { (response, result) in
            if(result["status"].numberValue != 0){
                
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                self.setEmailTextFieldBorder(error: true)
                self.setPasswordTextFieldBorder(error: true)
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
        self.login()
        
    }
    
    @IBAction func register(_ sender: Any) {
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

