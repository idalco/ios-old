//
//  WelcomeVC.swift
//  Finda
//
//  Created by Peter Lloyd on 07/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

//    @IBOutlet weak var splashImage: UIImageView!
    
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    
//    var images:[String] = []
//    var timer = Timer()
//    var photoCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        images = ["newsplash1","newsplash2","newsplash3"]
//        splashImage.image = UIImage.init(named: "newsplash1")
//        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(onTransition), userInfo: nil, repeats: true)
        
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
//        UIApplication.shared.statusBarStyle = .lightContent
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.signInButton.applyWidthGradient(colors: [UIColor(hexString: "7e73d6").cgColor, UIColor(hexString: "d441e8").cgColor])
//        self.signInButton.addLongShadow()
//        self.joinButton.applyWidthGradient(colors: [UIColor(hexString: "1fa3c5").cgColor, UIColor(hexString: "7978d6").cgColor])
        
//        self.signInButton.tintColor = UIColor.white
//        self.signInButton.setTitle("SIGN IN", for: .normal)
//        self.joinButton.tintColor = UIColor.white
//        self.joinButton.setTitle("JOIN US", for: .normal)

    }
    
//    @objc func onTransition() {
//        if (photoCount < images.count - 1){
//            photoCount = photoCount  + 1;
//        } else {
//            photoCount = 0;
//        }
//
//        UIView.transition(with: self.splashImage, duration: 2.0, options: .transitionCrossDissolve, animations: {
//            self.splashImage.image = UIImage.init(named: self.images[self.photoCount])
//        }, completion: nil)
//    }
    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension UIButton
//{
//    func applyWidthGradient(colors: [CGColor]) {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = colors
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
//        gradientLayer.frame = self.bounds
//        gradientLayer.cornerRadius = 2
//        self.layer.insertSublayer(gradientLayer, at: 0)
//    }
//
//    func addLongShadow() {
//
//
//    }
//}

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
