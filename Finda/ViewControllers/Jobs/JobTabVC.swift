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
            viewController.jobType = .offered
            self.viewControllers.append(viewController)
        }
        
//        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Jobs") as? JobsVC {
//            viewController.jobType = .optioned
//            self.viewControllers.append(viewController)
//        }
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Jobs") as? JobsVC {
            viewController.jobType = .accepted
            self.viewControllers.append(viewController)
        }
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Jobs") as? JobsVC {
            viewController.jobType = .all
            self.viewControllers.append(viewController)
        }
        
      
        
         self.bar.items = [Item(title: "Requested"), Item(title: "Accepted"), Item(title: "All")]
        
        self.bar.style = .buttonBar
//        self.bar.appearance?.style.background = TabmanBar.BackgroundView.Style.solid(color: UIColor.white)
//        self.bar.appearance?.style.background = TabmanBar.BackgroundView.Style.solid(color: UIColor.FindaColours.DarkYellow)
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            // customize appearance here
            appearance.text.font = UIFont(name: "Gotham-Medium", size: 16)
            appearance.indicator.color = UIColor.FindaColours.Blue
            appearance.state.selectedColor = UIColor.FindaColours.Blue
        })
        self.dataSource = self
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
