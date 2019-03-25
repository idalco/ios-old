//
//  JobTabVC.swift
//  Finda
//
//  Created by Peter Lloyd on 13/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import Tabman
import Pageboy

class JobTabVC: TabmanViewController, PageboyViewControllerDataSource {
   
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Jobs") as? JobsVC {
            viewController.jobType = .accepted
            self.viewControllers.append(viewController)
        }
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Jobs") as? JobsVC {
            viewController.jobType = .offered
            self.viewControllers.append(viewController)
        }
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Jobs") as? JobsVC {
            viewController.jobType = .all
            self.viewControllers.append(viewController)
        }
        
        self.bar.items = [Item(title: "Upcoming"), Item(title: "Offers"), Item(title: "History")]
        
//        self.bar.style = .scrollingButtonBar
        self.bar.style = .buttonBar
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            // customize appearance here
            appearance.text.font = UIFont(name: "Gotham-Medium", size: 16)
            appearance.indicator.color = UIColor.FindaColours.Blue
            appearance.state.selectedColor = UIColor.FindaColours.Blue
            appearance.layout.interItemSpacing = 0
        })
        self.dataSource = self

        // can we move to the view now?
//        let preferences = UserDefaults.standard
//        
//        let currentLevelKey = "showJobIdCard"
//        var showJobId = 0
//        if preferences.object(forKey: currentLevelKey) == nil {
//            //  Doesn't exist
//        } else {
//            showJobId = preferences.integer(forKey: "showJobIdCard")
//        }

//        if showJobId != 0 {
//            // move to the ALL tab
//            self.scrollToIndex(indexOf: 2)
//        }
        
    }
    
    func scrollToIndex(indexOf:Int) {
        scrollToPage(.at(index: indexOf), animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateNotificationCount()
        
    }
    
    private func updateNotificationCount(){
        NotificationManager.countNotifications(notificationType: .new) { (response, result) in
            if response {
                self.tabBarController?.tabBar.items?[1].badgeValue = result["userdata"].string
            }
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return self.viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return self.viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    @IBAction func menu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
}
