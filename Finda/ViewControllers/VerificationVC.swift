//
//  VerificationVC.swift
//  Finda
//
//  Created by Peter Lloyd on 03/09/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import YPImagePicker
import SVProgressHUD

class VerificationVC: UIViewController {
    
    @IBOutlet weak var legalText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text: String = """
To make sure everyone gets the best professional experience at Finda, we verify and approve each model as well as each creative before they can access the full website. \n\nWe need the following details and documentation from you before you can be seen by Finda clients:
        
A form of your ID document is required by our payment provider Stripe, please refer to our Privacy Policy. We accept any of the following IDs: \n
• A photo of your passport, clearly showing your photograph and date of birth; or \n
• A photo of your driver's license, clearly showing your photograph and date of birth; or \n
• A photo of another form of government-issued identification, clearly showing your photograph and date of birth. \n
Your country of residence and date of birth (under your Profile Details). \n
Your Instagram handle. \n
Your correct measurements (fill them in at ‘My details’ page). \n
Your portfolio photographs and polaroids \n
        
        
"""
        let attributedString = NSMutableAttributedString(string: text)

       
        if let font = UIFont(name: "Gotham-Medium", size: 12) {
            attributedString.addAttribute(.foregroundColor, value: UIColor.FindaColours.Blue, range: text.range(substring: "we verify and approve"))
            attributedString.addAttribute(.font, value: font, range: text.range(substring: "we verify and approve"))
            
            
            attributedString.addAttribute(.font, value: font, range: text.range(substring: "before you can be seen by Finda clients"))
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.FindaColours.Blue, range: text.range(substring: "A form of your ID document"))
            attributedString.addAttribute(.font, value: font, range: text.range(substring: "A form of your ID document"))
            
            
            attributedString.addAttribute(.link, value: "\(domainURL)/privacy", range: text.range(substring: "Privacy Policy"))
            attributedString.addAttribute(.foregroundColor, value: UIColor.FindaColours.Blue, range: text.range(substring: "Privacy Policy"))
            
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.FindaColours.Blue, range: text.range(substring: "country of residence and date of birth"))
            attributedString.addAttribute(.font, value: font, range: text.range(substring: "country of residence and date of birth"))
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.FindaColours.Blue, range: text.range(substring: "Instagram handle"))
            attributedString.addAttribute(.font, value: font, range: text.range(substring: "Instagram handle"))
            
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.FindaColours.Blue, range: text.range(substring: "correct measurements"))
            attributedString.addAttribute(.font, value: font, range: text.range(substring: "correct measurements"))
            
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.FindaColours.Blue, range: text.range(substring: "portfolio photographs and polaroids"))
            attributedString.addAttribute(.font, value: font, range: text.range(substring: "portfolio photographs and polaroids"))
            
        }
    
        
        let linkAttributes: [String : Any] = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.FindaColours.Blue,
//            NSAttributedStringKey.underlineColor.rawValue: UIColor.FindaColors.Purple,
//            NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleThick.rawValue
        ]
        
        
        legalText.linkTextAttributes = linkAttributes
        legalText.attributedText = attributedString
        
 

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToInvoices()
        LoginManager.getDetails { (response, result) in
            if response {
                self.changeToInvoices()
            }
        }
    }
    
    @IBAction func uploadImage(){
        self.uploadVerification()
    }
    
    func uploadVerification(){
        var config = YPImagePickerConfiguration()
        config.showsFilters = false
        config.startOnScreen = .library
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.image) // Final image selected by the user
                SVProgressHUD.show()
                FindaAPISession(target: .uploadVerificationImage(image: photo.image), completion: { (response, result) in
                    if response {
                        LoginManager.getDetails(completion: { (response, result) in
                            SVProgressHUD.showSuccess(withStatus: "Uploaded")
                            if response {
                                self.changeToInvoices()
                            }
                        })
                    } else {
                        SVProgressHUD.showError(withStatus: "Try again")
                    }
                    
                })
            }
            picker.dismiss(animated: true, completion: nil)
            
        }
        present(picker, animated: true, completion: nil)
    }

    func changeToInvoices(){
        let modelManager = ModelManager()
        if modelManager.kycOn() != -1 && modelManager.kycBy() != -1 && modelManager.kycOn() != 0 && modelManager.kycBy() != 0 {
//            sideMenuController?.setContentViewController(with: "InvoiceNav", animated: true, completion: {
//
//            })
        }
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
