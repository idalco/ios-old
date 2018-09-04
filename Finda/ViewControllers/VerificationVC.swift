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

    override func viewDidLoad() {
        super.viewDidLoad()

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
