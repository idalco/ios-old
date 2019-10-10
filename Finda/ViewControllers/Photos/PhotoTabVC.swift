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
//        self.bar.appearance?.style.background = TabmanBar.BackgroundView.Style.solid(color: UIColor.white)
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            // customize appearance here
            appearance.text.font = UIFont(name: "Montserrat-Medium", size: 16)
            appearance.indicator.color = UIColor.FindaColours.White
            appearance.state.selectedColor = UIColor.FindaColours.White
            appearance.state.color = UIColor.FindaColours.LightGrey
            appearance.style.background = .solid(color: UIColor.FindaColours.Burgundy)
        })
        self.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateNotificationCount()
//        self.tabBarController?.tabBar.barTintColor = UIColor.FindaColours.Burgundy
        navigationItem.title = "Photos"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.tabBarController?.tabBar.barTintColor = UIColor.FindaColours.Burgundy
    }
    
    private func updateNotificationCount() {
        NotificationManager.countNotifications(notificationType: .new) { (response, result) in
            if response {
                let count = result["userdata"].numberValue
                if count != 0 {
                    self.tabBarController?.tabBar.items?[2].badgeValue = result["userdata"].stringValue
                } else {
                    self.tabBarController?.tabBar.items?[2].badgeValue = nil
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

