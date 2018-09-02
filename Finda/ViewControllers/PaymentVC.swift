//
//  PaymentVC.swift
//  Finda
//
//  Created by Peter Lloyd on 20/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD

class PaymentVC: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sortCodeTextField: UITextField!
    @IBOutlet weak var accountNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.setBottomBorderLogin()
        self.sortCodeTextField.setBottomBorderLogin()
        self.accountNumberTextField.setBottomBorderLogin()

        // Do any additional setup after loading the view.
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
    
    func submitDetails(){
        SVProgressHUD.show()
        FindaAPISession(target: .updateBankDetails(name: self.nameTextField.text ?? "", sortcode: self.sortCodeTextField.text ?? "", accountNumber: self.accountNumberTextField.text ?? "")) { (response, result) in
            if response {
                SVProgressHUD.showSuccess(withStatus: "Done")
            } else {
                SVProgressHUD.showError(withStatus: "Try again")
            }
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

