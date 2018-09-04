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
        
//        self.updateRows()
//
//        form +++ Section(){ section in
//            var header = HeaderFooterView<UIView>(.class)
//            header.height = {70}
//            header.onSetupView = { view, _ in
//                view.backgroundColor = UIColor.FindaColors.White
//                let title = UILabel(frame: CGRect(x:10,y: 5, width:self.view.frame.width, height:40))
//
//                title.text = "Password Management"
//                title.font = UIFont(name: "Gotham-Medium", size: 17)
//                view.addSubview(title)
//
//                let description = UILabel(frame: CGRect(x:10,y: 40, width:self.view.frame.width, height:20))
//                description.numberOfLines = 0
////                description.text = "Set your email contact preferences."
//                description.font = UIFont(name: "Gotham-Light", size: 13)
//                view.addSubview(description)
//
//            }
//            section.header = header
//            }
//
//            <<< TextRow(){ row in
//                row.title = "Old Password"
//                row.tag = "old password"
//
//            }
//
//
//            <<< TextRow(){ row in
//                row.title = "New Password"
//                row.tag = "new password"
//
//            }
//
//
//            <<< TextRow(){ row in
//                row.title = "Repeat New Password"
//                row.tag = "repeat new password"
//
//            }


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
    
//    private func updatePassword(){
//        guard let oldPasswordRow: BaseRow = form.rowBy(tag: "old password"), let oldPassword: String = form.values()["old password"] as? String else {
//            self.validateRow(tag: "old password")
//            return
//        }
//
//        guard let newPasswordRow: BaseRow = form.rowBy(tag: "new password"), let newPassword: String = form.values()["new password"] as? String else {
//            self.validateRow(tag: "new password")
//            return
//        }
//
//        guard let repeatNewPasswordRow: BaseRow = form.rowBy(tag: "repeat new password"), let repeatNewPassword: String = form.values()["repeat new password"] as? String else {
//            self.validateRow(tag: "repeat new password")
//            return
//        }
//
//        if oldPasswordRow.isValid && newPasswordRow.isValid && repeatNewPasswordRow.isValid {
//            SVProgressHUD.show()
//            FindaAPISession(target: .updatePassword(oldPassword: oldPassword, newPassword: newPassword, repeatNewPassword: repeatNewPassword)) { (response, result) in
//                if response {
//                    SVProgressHUD.showSuccess(withStatus: "Updated")
//                } else {
//                    SVProgressHUD.showError(withStatus: "Try again")
//                }
//            }
//        }
//
//    }
//
//    func validateRow(tag: String){
//        let row: BaseRow? = form.rowBy(tag: tag)
//        _ = row?.validate()
//    }
    
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
