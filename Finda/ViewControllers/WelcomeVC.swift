//
//  WelcomeVC.swift
//  Finda
//
//  Created by Peter Lloyd on 07/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationController?.navigationBar.transparentNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var barStyle = UIStatusBarStyle.lightContent
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return barStyle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {

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

extension UIColor {
    convenience init(hexString: String, alpha:CGFloat? = 1.0) {
        var hexInt: UInt32 = 0
        let scanner = Scanner(string: hexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        
        let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
