//
//  PaymentVC.swift
//  Finda
//
//  Created by Peter Lloyd on 20/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import SCLAlertView

class PaymentVC: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sortCodeTextField: UITextField!
    @IBOutlet weak var accountNumberTextField: UITextField!
    
    @IBOutlet weak var ibanNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.setBottomBorderLogin()
        self.sortCodeTextField.setBottomBorderLogin()
        self.accountNumberTextField.setBottomBorderLogin()

        self.ibanNumberTextField.setBottomBorderLogin()
        
        // Do any additional setup after loading the view.
        
        self.sortCodeTextField.addTarget(self, action: #selector(accountFieldDidChange(_:)), for: .editingChanged)
        self.accountNumberTextField.addTarget(self, action: #selector(accountFieldDidChange(_:)), for: .editingChanged)
        self.ibanNumberTextField.addTarget(self, action: #selector(ibanFieldDidChange(_:)), for: .editingChanged)


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menu(_ sender: Any) {
        sideMenuController?.revealMenu()
        
    }
    
    @IBAction func submit(_ sender: Any) {
        self.submitDetails()
    }
    
    @objc func accountFieldDidChange(_ textField: UITextField) {
        self.ibanNumberTextField.text = ""
    }
    
    @objc func ibanFieldDidChange(_ textField: UITextField) {
        self.sortCodeTextField.text = ""
        self.accountNumberTextField.text = ""
    }
    
    func submitDetails() {
        
        let name = self.nameTextField.text ?? ""
        var sortcode = self.sortCodeTextField.text ?? ""
        var accountnumber = self.accountNumberTextField.text ?? ""
        let ibannumber = self.ibanNumberTextField.text ?? ""
        
        var error = false
        
        if ibannumber != "" {
            sortcode = ""
            accountnumber = ""
        }
        
        if ibannumber == "" {
            if (sortcode == "" && accountnumber != "") || (sortcode != "" && accountnumber == "") {
                error = true
            }
            if sortcode == "" && accountnumber == "" {
                error = true
            }
        }
        
        let appearance = SCLAlertView.SCLAppearance()

        if !error {
            SVProgressHUD.setBackgroundColor(UIColor.FindaColours.LightGrey)
            SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
            SVProgressHUD.show()
            FindaAPISession(target: .updateBankDetails(name: name, sortcode: sortcode, accountNumber: accountnumber, ibanNumber: ibannumber)) { (response, result) in
                if response {
                    let noticeView = SCLAlertView(appearance: appearance)
                    SVProgressHUD.dismiss()
                    noticeView.showInfo("Details Saved", subTitle: "", colorStyle: 0x13AFC0)
//                    SVProgressHUD.setBackgroundColor(UIColor.FindaColours.LightGrey)
//                    SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
//                    SVProgressHUD.showSuccess(withStatus: "Done")
                } else {
                    SVProgressHUD.dismiss()
                    let errorView = SCLAlertView(appearance: appearance)
                    errorView.showError(
                        "Sorry",
                        subTitle: "Something went wrong saving your details. Please try again later.")
                    
//                    SVProgressHUD.setBackgroundColor(UIColor.FindaColours.LightGrey)
//                    SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
//                    SVProgressHUD.showError(withStatus: "Try again")
                }
            }
        } else {
            
            let errorView = SCLAlertView(appearance: appearance)
            errorView.showError(
                "Sorry",
                subTitle: "Please fill in either your Sortcode and Account Number, or your IBAN number.")
            
        }
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


extension PaymentVC: UITextFieldDelegate {
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
            self.submitDetails()
        }
        
        return false; // We do not want UITextField to insert line-breaks.
    }
}

