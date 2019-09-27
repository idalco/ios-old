//
//  SupportVC.swift
//  Finda
//
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import DCKit

class SupportVC: UIViewController {
    
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var supportText: UITextView!
    @IBOutlet weak var backButton: UIImageView!
    
    @IBOutlet weak var option1: UISwitch!
    @IBOutlet weak var option2: UISwitch!
    @IBOutlet weak var option3: UISwitch!
    @IBOutlet weak var option4: UISwitch!
    @IBOutlet weak var option5: UISwitch!
    
    var selectedReason: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(SupportVC.backButtonTapped))
        backButton.addGestureRecognizer(tapRec)
        backButton.isUserInteractionEnabled = true
        
        emailButton.addTarget(self, action: #selector(emailButtonTapped(sender:)), for: .touchUpInside)
        phoneButton.addTarget(self, action: #selector(phoneButtonTapped(sender:)), for: .touchUpInside)
        
        option1.tag = 1
        option1.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        option2.tag = 2
        option2.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        option3.tag = 3
        option3.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        option4.tag = 4
        option4.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        option5.tag = 5
        option5.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)

        resetButtons()
    }
    
    func resetButtons() {
        option1.setOn(false, animated: true)
        option2.setOn(false, animated: true)
        option3.setOn(false, animated: true)
        option4.setOn(false, animated: true)
        option5.setOn(true, animated: true) // other
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    @IBAction func submit(_ sender: Any) {
        self.submitRequest()
    }
    
    @objc func optionTapped(sender: UISwitch) {
        let option = sender.tag
        option1.setOn(false, animated: true)
        option2.setOn(false, animated: true)
        option3.setOn(false, animated: true)
        option4.setOn(false, animated: true)
        option5.setOn(false, animated: true)
        self.selectedReason = option
        switch (option) {
        case 1:
            if option1.isOn {
                option1.setOn(false, animated: true)
            } else {
                option1.setOn(true, animated: true)
            }
            break
        case 2:
            option2.setOn(true, animated: true)
            break
        case 3:
            option3.setOn(true, animated: true)
            break
        case 4:
            option4.setOn(true, animated: true)
            break
        case 5:
            option5.setOn(true, animated: true)
            break
        default:
            break
        }
    }
    
    func submitRequest() {
        SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Black)
        SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
        SVProgressHUD.show()
        
        let request = self.supportText.text
        
        FindaAPISession(target: .supportRequest(request: request!, reason: selectedReason)) { (response, result) in
            if response {
                SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Black)
                SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
                SVProgressHUD.showSuccess(withStatus: "Support Request Sent")
                self.supportText.text = ""
                self.resetButtons()
            } else {
                SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Black)
                SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
                SVProgressHUD.showError(withStatus: "Sorry, there was a problem, please try again")
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
    
    @objc private func backButtonTapped(sender: UIImageView) {
        self.dismiss(animated: true)
    }
    
    @objc private func emailButtonTapped(sender: UIButton) {
        let appURL = URL(string: "mailto:support@finda.co")!
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(appURL as URL)
        }
    }
    
    @objc private func phoneButtonTapped(sender: UIButton) {
        
        if let phoneCallURL = URL(string: "telprompt://+448443570556") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }

}

extension SupportVC: UITextFieldDelegate {
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
            self.submitRequest()
        }
        
        return false; // We do not want UITextField to insert line-breaks.
    }
}
