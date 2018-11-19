//
//  TabBarController.swift
//  Finda
//
//  Created by Peter Lloyd on 25/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    static let didReceiveData = NSNotification.Name("didReceiveData")
    static let didCompleteTask = NSNotification.Name("didCompleteTask")
    static let completedLengthyDownload = NSNotification.Name("completedLengthyDownload")
}

class TabBarController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.FindaColours.Blue
        self.tabBar.tintColor = UIColor.FindaColours.White
        self.tabBar.unselectedItemTintColor = UIColor.FindaColours.Black
        

        // Do any additional setup after loading the view.
        
//        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData , object: nil)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onDidReceiveData(_ notification: NSNotification) {
        
        print("Inside on receive in toolbar")
        if let data = notification.userInfo as? [String: Any] {
            print(data["badge"] as! String)
            
//            self.tabBar.items?[1].badgeValue = data["badge"] as? String
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
