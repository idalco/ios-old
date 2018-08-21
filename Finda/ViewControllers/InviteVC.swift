//
//  InviteVC.swift
//  Finda
//
//  Created by Peter Lloyd on 20/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit

class InviteVC: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var referralCodeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.setBottomBorderLogin()
        self.emailTextField.setBottomBorderLogin()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let modelManager = ModelManager()
        if modelManager.referrerCode() != "" {
            self.referralCodeLabel.text = "Here is your code: \(modelManager.referrerCode())"
        } else {
            self.referralCodeLabel.text = "Please add a referral code within your preferences"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    @IBAction func submit(_ sender: Any) {
        print("submit")
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
