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
        
//        let modelManager = ModelManager()
//        
//        let newtext = NSMutableAttributedString(string: "Hi ")
//
//        let name = NSMutableAttributedString(string: modelManager.firstName())
//
//        let line1 = NSMutableAttributedString(string: ",\n\nThank you for registering with us!\n\nTo make sure everyone gets the best professional experience at FINDA, we verify and approve all models and clients before they can access the full platform.\n\nFor verification ")
//
//        let words1 = NSMutableAttributedString(string: "all items")
//        let line2 = NSMutableAttributedString(string: " below must be submitted:")
//        let words2 = NSMutableAttributedString(string: "• passport")
//        let line3 = NSMutableAttributedString(string: ", ")
//        let words3 = NSMutableAttributedString(string: "• driving licence")
//        let line4 = NSMutableAttributedString(string: " or another form of government-issued photo identification for verification.\n\nTo increase the speed of the process, please upload your professional modelling ")
//        let words4 = NSMutableAttributedString(string: "portfolio")
//        let line5 = NSMutableAttributedString(string: ", ")
//        let words5 = NSMutableAttributedString(string: "polaroids")
//        let line6 = NSMutableAttributedString(string: " and enter your ")
//        let words6 = NSMutableAttributedString(string: "measurements")
//        let line7 = NSMutableAttributedString(string: " under My Details.\n\nYou will receive an email if your application is accepted and you have been verified.")
//
//        let baseParagraphStyle = NSMutableParagraphStyle()
//        baseParagraphStyle.alignment = .left
//        baseParagraphStyle.lineSpacing = 4
//        baseParagraphStyle.paragraphSpacing = 0
//
//        let indentParagraphStyle = NSMutableParagraphStyle()
//        indentParagraphStyle.headIndent = 16
//        indentParagraphStyle.firstLineHeadIndent = 0
//
//        if let mainfont = UIFont(name: "Montserrat-Regular", size: 16) {
//            newtext.addAttribute(.font, value: mainfont, range: NSMakeRange(0, newtext.length))
//            line1.addAttribute(.font, value: mainfont, range: NSMakeRange(0, line1.length))
//            name.addAttribute(.font, value: mainfont, range: NSMakeRange(0, name.length))
//            line2.addAttribute(.font, value: mainfont, range: NSMakeRange(0, line2.length))
//            line3.addAttribute(.font, value: mainfont, range: NSMakeRange(0, line3.length))
//            line4.addAttribute(.font, value: mainfont, range: NSMakeRange(0, line4.length))
//            line5.addAttribute(.font, value: mainfont, range: NSMakeRange(0, line5.length))
//            line6.addAttribute(.font, value: mainfont, range: NSMakeRange(0, line6.length))
//            line7.addAttribute(.font, value: mainfont, range: NSMakeRange(0, line7.length))
//        }
//
//        if let boldfont = UIFont(name: "Montserrat-Bold", size: 16) {
//            words1.addAttribute(.font, value: boldfont, range: NSMakeRange(0, words1.length))
//            words2.addAttribute(.font, value: boldfont, range: NSMakeRange(0, words2.length))
//            words3.addAttribute(.font, value: boldfont, range: NSMakeRange(0, words3.length))
//            words4.addAttribute(.font, value: boldfont, range: NSMakeRange(0, words4.length))
//            words5.addAttribute(.font, value: boldfont, range: NSMakeRange(0, words5.length))
//            words6.addAttribute(.font, value: boldfont, range: NSMakeRange(0, words6.length))
//        }
//
//        newtext.append(name)
//        newtext.append(line1)
//        newtext.append(words1)
//        newtext.append(line2)
//        newtext.append(words2)
//        newtext.append(line3)
//        newtext.append(words3)
//        newtext.append(line4)
//        newtext.append(words4)
//        newtext.append(line5)
//        newtext.append(words5)
//        newtext.append(line6)
//        newtext.append(words6)
//        newtext.append(line7)
//
//        newtext.addAttributes([.paragraphStyle: baseParagraphStyle], range: NSRange(location: 0, length: newtext.length))
//                
//        legalText.attributedText = newtext
        
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
                
                SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Black)
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
                                colorStyle: 0x010101,
                                colorTextButton: 0xFFFFFF)
                        })
                    } else {
                        SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Black)
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
