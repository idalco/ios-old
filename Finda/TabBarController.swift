//
//  TabBarController.swift
//  Finda
//
//  Created by Peter Lloyd on 25/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import SCLAlertView

extension NSNotification.Name {
    static let didReceiveData = NSNotification.Name("didReceiveData")
    static let didCompleteTask = NSNotification.Name("didCompleteTask")
    static let completedLengthyDownload = NSNotification.Name("completedLengthyDownload")
}

class TabBarController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.FindaColours.LightGrey
        self.tabBar.tintColor = UIColor.FindaColours.White
        self.tabBar.unselectedItemTintColor = UIColor.FindaColours.Black

        // Do any additional setup after loading the view.
        
//        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData , object: nil)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        
        // Do something with the index
  
        let modelManager = ModelManager()
        if modelManager.status() == UserStatus.unverified {
            if index == 0 || index == 1 {
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alertView = SCLAlertView(appearance: appearance)
                var subtitle = ""
                if index == 0 {
                    subtitle = "You will be able to see your jobs once you have been verified"
                } else if index == 1 {
                    subtitle = "You will be able to see your updates once you have been verified"
                }
                alertView.addButton("OK") {
                    let smc = self.sideMenuController
                    smc?.setContentViewController(with: "MainTabBar")
                    (smc?.contentViewController as? UITabBarController)?.selectedIndex = 2
                }
                alertView.showTitle(
                    "Waiting for Verification",
                    subTitle: subtitle,
                    style: .info,
                    closeButtonTitle: "Close",
                    colorStyle: 0x13AFC0,
                    colorTextButton: 0xFFFFFF)
                
            }
        }
        
    }
    
    @objc func onDidReceiveData(_ notification: NSNotification) {
        
//        print("Inside on receive in toolbar")
//        if let data = notification.userInfo as? [String: Any] {
//            print(data["badge"] as! String)
        
//            self.tabBar.items?[3].badgeValue = data["badge"] as? String
//        }
    
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
