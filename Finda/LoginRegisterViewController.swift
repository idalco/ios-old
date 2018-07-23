//
//  LoginRegisterViewController.swift
//  Finda
//

import UIKit
import SVProgressHUD

class LoginRegisterViewController: UIViewController {
    
    @IBOutlet weak var loginButtonStackView: UIStackView!
    @IBOutlet weak var formContainer: UIView!
    @IBOutlet weak var formContainerTopConstraint: NSLayoutConstraint!
    
    let formVC: LoginRegisterFormViewController
    
    init(formMode: LoginRegisterFormViewController.FormMode, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.formVC = LoginRegisterFormViewController(formMode: formMode, style: .grouped)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.formVC = LoginRegisterFormViewController(formMode: .register, style: .grouped)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addChildViewController(formVC)
        formVC.view.frame = formContainer.bounds
        formVC.topLayoutConstraint = formContainerTopConstraint
        formVC.containerView = self.view
        formContainer.addSubview(formVC.view)
        formVC.didMove(toParentViewController: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertWithTitle(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


