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

class SettingsTabVC: TabmanViewController, PageboyViewControllerDataSource {

    
    @IBOutlet weak var fakeJobsTab: UIView!
    @IBOutlet weak var fakeUpdatesTab: UIView!
    @IBOutlet weak var fakePortfolioTab: UIView!
    @IBOutlet weak var fakeCalendarTab: UIView!
    

    
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PersonalDetails") as? PersonalDetailsVC {
            self.viewControllers.append(viewController)
        }
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Measurements") as? MeasurementsVC {
            self.viewControllers.append(viewController)
        }
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Preferences") as? PreferencesVC {
            self.viewControllers.append(viewController)
        }
        
//        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Calendar" as? CalendarVC) {
//            self.viewControllers.append(viewController)
//        }
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Password") as? PasswordVC {
            self.viewControllers.append(viewController)
        }
        
        self.bar.items = [Item(title: "Profile"), Item(title: "Measurements"), Item(title: "Preferences"), Item(title: "Password")]
        
        self.bar.style = .scrollingButtonBar
        self.bar.appearance?.style.background = TabmanBar.BackgroundView.Style.solid(color: UIColor.white)
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            // customize appearance here
            appearance.text.font = UIFont(name: "Gotham-Medium", size: 16)
            appearance.indicator.color = UIColor.FindaColours.Blue
            appearance.state.selectedColor = UIColor.FindaColours.Blue
        })
        self.dataSource = self

        // Do any additional setup after loading the view.
        let fakeJobsTap = UITapGestureRecognizer(target: self, action: #selector(userDidTapFakeJobButton))
        fakeJobsTab.addGestureRecognizer(fakeJobsTap)

        let fakeCalendarTap = UITapGestureRecognizer(target: self, action: #selector(userDidTapFakeCalendarButton))
        fakeCalendarTab.addGestureRecognizer(fakeCalendarTap)

        let fakeUpdatesTap = UITapGestureRecognizer(target: self, action: #selector(userDidTapFakeUpdatesButton))
        fakeUpdatesTab.addGestureRecognizer(fakeUpdatesTap)
        
        let fakePortfolioTap = UITapGestureRecognizer(target: self, action: #selector(userDidTapFakePortfolioButton))
        fakePortfolioTab.addGestureRecognizer(fakePortfolioTap)
        
    }
    
    @objc func userDidTapFakeJobButton(sender: Any?) {
        
        let modelManager = ModelManager()
        if modelManager.status() == UserStatus.unverified {
            let appearance = SCLAlertView.SCLAppearance()
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.showTitle(
                "Waiting for Verification",
                subTitle: "You will be able to see your jobs once you have been verified",
                style: .info,
                closeButtonTitle: "OK",
                colorStyle: 0x13AFC0,
                colorTextButton: 0xFFFFFF)
        } else {
            let smc = sideMenuController
            smc?.setContentViewController(with: "MainTabBar")
            (smc?.contentViewController as? UITabBarController)?.selectedIndex = 0
        }
        
    }
    
    @objc func userDidTapFakeCalendarButton(sender: Any?) {
        
        let modelManager = ModelManager()
        if modelManager.status() == UserStatus.unverified {
            let appearance = SCLAlertView.SCLAppearance()
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.showTitle(
                "Waiting for Verification",
                subTitle: "You will be able to see your jobs once you have been verified",
                style: .info,
                closeButtonTitle: "OK",
                colorStyle: 0x13AFC0,
                colorTextButton: 0xFFFFFF)
        } else {
            let smc = sideMenuController
            smc?.setContentViewController(with: "MainTabBar")
            (smc?.contentViewController as? UITabBarController)?.selectedIndex = 1
        }
        
    }

    @objc func userDidTapFakeUpdatesButton(sender: Any?) {
        let modelManager = ModelManager()
        if modelManager.status() == UserStatus.unverified {
            let appearance = SCLAlertView.SCLAppearance()
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.showTitle(
                "Waiting for Verification",
                subTitle: "You will be able to see your updates once you have been verified",
                style: .info,
                closeButtonTitle: "OK",
                colorStyle: 0x13AFC0,
                colorTextButton: 0xFFFFFF)
        } else {
            let smc = sideMenuController
            smc?.setContentViewController(with: "MainTabBar")
            (smc?.contentViewController as? UITabBarController)?.selectedIndex = 2
        }
    }
    
    @objc func userDidTapFakePortfolioButton(sender: Any?) {
        let smc = sideMenuController
        smc?.setContentViewController(with: "MainTabBar")
        (smc?.contentViewController as? UITabBarController)?.selectedIndex = 3
        (((smc?.contentViewController as? UITabBarController)?.selectedViewController)?.children[0] as? PhotoTabVC)?.scrollToPage(.first, animated: true)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
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

}
