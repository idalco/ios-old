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
import SCLAlertView

class VerificationVC: UIViewController {
    
    @IBOutlet weak var legalText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let newtext = NSMutableAttributedString(string: "Before you can start using our platform we need to verify you to:\n")
        let faline1 = NSMutableAttributedString(string: "   Confirm your identity\n")
        let faline2 = NSMutableAttributedString(string: "   Provide correct information to our clients and creatives\n")
        let faline3 = NSMutableAttributedString(string: "   Enable you to receive payments\n\n\n")

        let faline3a = NSMutableAttributedString(string: "Accepted IDs:\n")

        let faline4 = NSMutableAttributedString(string: "   Passport\n")
        let faline5 = NSMutableAttributedString(string: "  Driver's license\n")
        let faline6 = NSMutableAttributedString(string: "   Another form of Government-issued identification\n\n\n")
        
        let faline6a = NSMutableAttributedString(string: "We need the following additional information:\n")

        let faline7 = NSMutableAttributedString(string: "  Country of Residence and Date of Birth (My Details)\n")
        let faline8 = NSMutableAttributedString(string: "  Instagram handle (My Details)\n")
        let faline9 = NSMutableAttributedString(string: "  Measurements (My Details)\n")
        let faline10 = NSMutableAttributedString(string: "  Portfolio pictures and polaroids\n")
        
        let baseParagraphStyle = NSMutableParagraphStyle()
        baseParagraphStyle.alignment = .left
        baseParagraphStyle.lineSpacing = 4
        baseParagraphStyle.paragraphSpacing = 0
        
        let indentParagraphStyle = NSMutableParagraphStyle()
        indentParagraphStyle.headIndent = 16
        indentParagraphStyle.firstLineHeadIndent = 0
        
        if let mainfont = UIFont(name: "Gotham-Book", size: 15) {
            newtext.addAttribute(.font, value: mainfont, range: NSMakeRange(0, newtext.length))
            faline1.addAttribute(.font, value: mainfont, range: NSMakeRange(2, faline1.length-2))
            faline2.addAttribute(.font, value: mainfont, range: NSMakeRange(2, faline2.length-2))
            faline2.addAttributes([.paragraphStyle: indentParagraphStyle], range: NSRange(location: 0, length: faline2.length))
            faline3.addAttribute(.font, value: mainfont, range: NSMakeRange(2, faline3.length-2))
            faline3a.addAttribute(.font, value: mainfont, range: NSMakeRange(0, faline3a.length))
            faline4.addAttribute(.font, value: mainfont, range: NSMakeRange(2, faline4.length-2))
            faline5.addAttribute(.font, value: mainfont, range: NSMakeRange(2, faline5.length-2))
            faline6.addAttribute(.font, value: mainfont, range: NSMakeRange(2, faline6.length-2))
            faline6.addAttributes([.paragraphStyle: indentParagraphStyle], range: NSRange(location: 0, length: faline6.length))
            faline6a.addAttribute(.font, value: mainfont, range: NSMakeRange(0, faline6a.length))
            faline7.addAttribute(.font, value: mainfont, range: NSMakeRange(2, faline7.length-2))
            faline7.addAttributes([.paragraphStyle: indentParagraphStyle], range: NSRange(location: 0, length: faline7.length))
            faline8.addAttribute(.font, value: mainfont, range: NSMakeRange(2, faline8.length-2))
            faline9.addAttribute(.font, value: mainfont, range: NSMakeRange(2, faline9.length-2))
            faline10.addAttribute(.font, value: mainfont, range: NSMakeRange(2, faline10.length-2))
        }
        if let fafont = UIFont(name: "FontAwesome5FreeSolid", size: 15) {
            // user
            faline1.addAttribute(.font, value: fafont, range: NSMakeRange(0, 2))
            faline1.addAttribute(NSAttributedString.Key.kern, value: CGFloat(2), range: NSMakeRange(0, 2))
            faline2.addAttribute(.font, value: fafont, range: NSMakeRange(0, 2))
            faline2.addAttribute(NSAttributedString.Key.kern, value: CGFloat(2), range: NSMakeRange(0, 2))
            faline3.addAttribute(.font, value: fafont, range: NSMakeRange(0, 2))
            faline3.addAttribute(NSAttributedString.Key.kern, value: CGFloat(2), range: NSMakeRange(0, 2))
            faline4.addAttribute(.font, value: fafont, range: NSMakeRange(0, 2))
            faline4.addAttribute(NSAttributedString.Key.kern, value: CGFloat(2), range: NSMakeRange(0, 2))
            faline5.addAttribute(.font, value: fafont, range: NSMakeRange(0, 2))
            faline5.addAttribute(NSAttributedString.Key.kern, value: CGFloat(2), range: NSMakeRange(0, 2))
            faline6.addAttribute(.font, value: fafont, range: NSMakeRange(0, 2))
            faline6.addAttribute(NSAttributedString.Key.kern, value: CGFloat(2), range: NSMakeRange(0, 2))
            faline7.addAttribute(.font, value: fafont, range: NSMakeRange(0, 2))
            faline7.addAttribute(NSAttributedString.Key.kern, value: CGFloat(2), range: NSMakeRange(0, 2))
            faline9.addAttribute(.font, value: fafont, range: NSMakeRange(0, 2))
            faline9.addAttribute(NSAttributedString.Key.kern, value: CGFloat(2), range: NSMakeRange(0, 2))
            faline10.addAttribute(.font, value: fafont, range: NSMakeRange(0, 2))
            faline10.addAttribute(NSAttributedString.Key.kern, value: CGFloat(2), range: NSMakeRange(0, 2))
        }
        
        if let fafont2 = UIFont(name: "FontAwesome", size: 15) {
            faline8.addAttribute(.font, value: fafont2, range: NSMakeRange(0, 2))
            faline8.addAttribute(NSAttributedString.Key.kern, value: CGFloat(2), range: NSMakeRange(0, 2))
        }
  
        newtext.append(faline1)
        newtext.append(faline2)
        newtext.append(faline3)
        newtext.append(faline3a)
        newtext.append(faline4)
        newtext.append(faline5)
        newtext.append(faline6)
        newtext.append(faline6a)
        newtext.append(faline7)
        newtext.append(faline8)
        newtext.append(faline9)
        newtext.append(faline10)
        
        newtext.addAttributes([.paragraphStyle: baseParagraphStyle], range: NSRange(location: 0, length: newtext.length))
        
        legalText.attributedText = newtext
        
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
        
        let appearance = SCLAlertView.SCLAppearance()
        let alertView = SCLAlertView(appearance: appearance)
        
        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.startOnScreen = .library
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.image) // Final image selected by the user
                
                SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Blue)
                SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
                SVProgressHUD.show(withStatus: "Uploading")
                FindaAPISession(target: .uploadVerificationImage(image: photo.image), completion: { (response, result) in
                    if response {
                        LoginManager.getDetails(completion: { (response, result) in
                            SVProgressHUD.dismiss()
                            alertView.showTitle(
                                "Thank you for your application to Finda",
                                subTitle: "We will be in touch once your account has been verified",
                                style: .success,
                                closeButtonTitle: "OK",
                                colorStyle: 0x13AFC0,
                                colorTextButton: 0xFFFFFF)
                        })
                    } else {
                        SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Blue)
                        SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
                        SVProgressHUD.showError(withStatus: "Try again")
                    }
                    
                })
            }
            picker.dismiss(animated: true, completion: nil)
            
        }
        present(picker, animated: true, completion: nil)
    }

    func changeToInvoices(){
        
//        let smc = sideMenuController
//        smc?.setContentViewController(with: "Settings", animated: true)
        
//        let modelManager = ModelManager()
//        if modelManager.kycOn() != -1 && modelManager.kycBy() != -1 && modelManager.kycOn() != 0 && modelManager.kycBy() != 0 {
//            sideMenuController?.setContentViewController(with: "Settings", animated: true, completion: {})
//        }
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
