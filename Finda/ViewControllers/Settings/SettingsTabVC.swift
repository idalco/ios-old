//
//  SettingsTabVC.swift
//  Finda
//
//  Created by Peter Lloyd on 04/09/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import SCLAlertView

class SettingsTabVC: TabmanViewController, PageboyViewControllerDataSource, UITabBarDelegate {

    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MY DETAILS"
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PersonalDetails") as? PersonalDetailsVC {
            self.viewControllers.append(viewController)
        }
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Measurements") as? MeasurementsVC {
            self.viewControllers.append(viewController)
        }
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Preferences") as? PreferencesVC {
            self.viewControllers.append(viewController)
        }
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Password") as? PasswordVC {
            self.viewControllers.append(viewController)
        }
        
        self.bar.items = [Item(title: "Profile"), Item(title: "Measurements"), Item(title: "Preferences"), Item(title: "Password")]
        
        self.bar.style = .scrollingButtonBar
        self.bar.appearance?.style.background = TabmanBar.BackgroundView.Style.solid(color: UIColor.white)
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            // customize appearance here
            appearance.text.font = UIFont(name: "Montserrat-Medium", size: 16)
            appearance.indicator.color = UIColor.FindaColours.White
            appearance.style.background = .solid(color: UIColor.FindaColours.Burgundy)
            appearance.state.selectedColor = UIColor.FindaColours.White
            appearance.state.color = UIColor.FindaColours.LightGrey
        })
        self.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            if let items = self.tabBarController?.tabBar.items {
                for item in items {
                    item.image?.withTintColor(UIColor.gray)
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {

//        if #available(iOS 11.0, *) {
//            view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            
        let smc = sideMenuController
        let modelManager = ModelManager()
        
        switch (item.tag) {

        // Jobs Tab
        case 1:
            if modelManager.status() == UserStatus.unverified || modelManager.status() == UserStatus.wewant || modelManager.status() == UserStatus.notsure {
                let appearance = SCLAlertView.SCLAppearance()
                let alertView = SCLAlertView(appearance: appearance)
                
                alertView.showTitle(
                    "Waiting for Verification",
                    subTitle: "You will be able to see your jobs once you have been verified",
                    style: .info,
                    closeButtonTitle: "OK",
                    colorStyle: 0x010101,
                    colorTextButton: 0xFFFFFF)
            } else {
                let smc = sideMenuController
                smc?.setContentViewController(with: "MainTabBar")
                (smc?.contentViewController as? UITabBarController)?.selectedIndex = 1
            }
            break
        // Calendar Tab
        case 2:
            if modelManager.status() == UserStatus.unverified || modelManager.status() == UserStatus.wewant || modelManager.status() == UserStatus.notsure {
                let appearance = SCLAlertView.SCLAppearance()
                let alertView = SCLAlertView(appearance: appearance)
                
                alertView.showTitle(
                    "Waiting for Verification",
                    subTitle: "You will be able to see your jobs once you have been verified",
                    style: .info,
                    closeButtonTitle: "OK",
                    colorStyle: 0x010101,
                    colorTextButton: 0xFFFFFF)
            } else {
                let smc = sideMenuController
                smc?.setContentViewController(with: "MainTabBar")
                (smc?.contentViewController as? UITabBarController)?.selectedIndex = 2
            }
            break
        // Updates Tab
        case 3:
            if modelManager.status() == UserStatus.unverified || modelManager.status() == UserStatus.wewant || modelManager.status() == UserStatus.notsure {
                let appearance = SCLAlertView.SCLAppearance()
                let alertView = SCLAlertView(appearance: appearance)
                
                alertView.showTitle(
                    "Waiting for Verification",
                    subTitle: "You will be able to see your updates once you have been verified",
                    style: .info,
                    closeButtonTitle: "OK",
                    colorStyle: 0x010101,
                    colorTextButton: 0xFFFFFF)
            } else {
                let smc = sideMenuController
                smc?.setContentViewController(with: "MainTabBar")
                (smc?.contentViewController as? UITabBarController)?.selectedIndex = 3
            }
            break
        // Photos Tab
        case 4:
            smc?.setContentViewController(with: "MainTabBar")
            (smc?.contentViewController as? UITabBarController)?.selectedIndex = 4
            (((smc?.contentViewController as? UITabBarController)?.selectedViewController)?.children[0] as? PhotoTabVC)?.scrollToPage(.first, animated: true)
            break
        // Home Tab
        default:
            smc?.setContentViewController(with: "MainTabBar")
            (smc?.contentViewController as? UITabBarController)?.selectedIndex = 0
            break
        }
    }

}
