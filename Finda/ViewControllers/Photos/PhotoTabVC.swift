//
//  PhotoTabVC.swift
//  Finda
//
//  Created by Peter Lloyd on 14/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class PhotoTabVC: TabmanViewController, PageboyViewControllerDataSource {
    
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Portfolio") {
            self.viewControllers.append(viewController)
        }
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Polaroids") {
            self.viewControllers.append(viewController)
        }

        self.bar.items = [Item(title: "Portfolio"), Item(title: "Polaroids")]
        
        self.bar.style = .buttonBar
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            // customize appearance here
            appearance.text.font = UIFont(name: "Montserrat-Medium", size: 16)
            appearance.indicator.color = UIColor.FindaColours.White
            appearance.state.selectedColor = UIColor.FindaColours.White
            appearance.state.color = UIColor.FindaColours.LightGrey
            appearance.style.background = .solid(color: UIColor.FindaColours.Burgundy)
        })
        self.dataSource = self
        
        let preferences = UserDefaults.standard
        let phototab = preferences.string(forKey: "photoTab")
        if phototab == "polaroids" {
            // force switch to the polaroids tab
            self.scrollToPage(.last, animated: true)
        }
        // clear preferences
        preferences.set("", forKey: "photoTab")
        preferences.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateNotificationCount()
        navigationItem.title = "PHOTOS"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    private func updateNotificationCount() {
        NotificationManager.countNotifications(notificationType: .new) { (response, result) in
            if response {
                let count = result["userdata"].numberValue
                if count != 0 {
                    self.tabBarController?.tabBar.items?[3].badgeValue = result["userdata"].stringValue
                } else {
                    self.tabBarController?.tabBar.items?[3].badgeValue = nil
                }
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

