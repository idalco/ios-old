//
//  PasswordVC.swift
//  Finda
//
//  Created by Peter Lloyd on 03/09/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
//import Eureka
import SVProgressHUD
import DCKit

class PasswordVC: UIViewController {
    
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var repeatNewPassword: UITextField!
    @IBOutlet weak var updateButton: DCRoundedButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateButton.normalBackgroundColor = UIColor.FindaColors.DarkYellow
        self.updateButton.normalTextColor = UIColor.FindaColors.Black

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupTextFields()
        self.updateRows()
    }
    
    private func updateRows(){
        LoginManager.getDetails { (response, result) in
        }
    }
    
    @IBAction func updatePassword(){
       self.update()
        
    }
    
    func update(){
        if self.currentPassword.text == "" {
            self.currentPassword.setBottomBorderLogin(borderColor: UIColor.FindaColors.FindaRed.cgColor)
            return
        }
        
        if self.newPassword.text == "" {
            self.newPassword.setBottomBorderLogin(borderColor: UIColor.FindaColors.FindaRed.cgColor)
            return
        }
        
        if self.repeatNewPassword.text == "" {
            self.repeatNewPassword.setBottomBorderLogin(borderColor: UIColor.FindaColors.FindaRed.cgColor)
            return
        }
        
        SVProgressHUD.show()
        FindaAPISession(target: .updatePassword(oldPassword: self.currentPassword.text ?? "", newPassword: self.newPassword.text ?? "", repeatNewPassword: self.repeatNewPassword.text ?? "")) { (response, result) in
            if response {
                SVProgressHUD.showSuccess(withStatus: "Updated")
                self.setupTextFields()
                
            } else {
                SVProgressHUD.showError(withStatus: "Try again")
                self.currentPassword.setBottomBorderLogin(borderColor: UIColor.FindaColors.FindaRed.cgColor )
                self.newPassword.setBottomBorderLogin(borderColor: UIColor.FindaColors.FindaRed.cgColor)
                self.repeatNewPassword.setBottomBorderLogin(borderColor: UIColor.FindaColors.FindaRed.cgColor)
                
            }
        }
    }
    
    private func setupTextFields(){
        self.currentPassword.text = ""
        self.newPassword.text = ""
        self.repeatNewPassword.text = ""
        self.currentPassword.setBottomBorderLogin()
        self.newPassword.setBottomBorderLogin()
        self.repeatNewPassword.setBottomBorderLogin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PasswordVC: UITextFieldDelegate {
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
            self.update()
        }
        
        return false; // We do not want UITextField to insert line-breaks.
    }
}
