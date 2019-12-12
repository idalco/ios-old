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
        self.tabBar.tintColor = UIColor.FindaColours.Burgundy
        self.tabBar.unselectedItemTintColor = UIColor.FindaColours.Black

        // Do any additional setup after loading the view.
        
        delegate = self

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
                    colorStyle: 0x010101,
                    colorTextButton: 0xFFFFFF)
                
            }
        }
        
    }
    
    @objc func onDidReceiveData(_ notification: NSNotification) {
            
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

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let tabViewControllers = tabBarController.viewControllers, let toIndex = tabViewControllers.index(of: viewController) else {
            return false
        }
        animateToTab(toIndex: toIndex)
        return true
    }
    
    func animateToTab(toIndex: Int) {
        guard let tabViewControllers = viewControllers,
            let selectedVC = selectedViewController else { return }
        
        guard let fromView = selectedVC.view,
            let toView = tabViewControllers[toIndex].view,
            let fromIndex = tabViewControllers.index(of: selectedVC),
            fromIndex != toIndex else { return }
        
        
        // Add the toView to the tab bar view
        fromView.superview?.addSubview(toView)
        
        // Position toView off screen (to the left/right of fromView)
        let screenWidth = UIScreen.main.bounds.size.width
        let scrollRight = toIndex > fromIndex
        let offset = (scrollRight ? screenWidth : -screenWidth)
        toView.center = CGPoint(x: fromView.center.x + offset, y: toView.center.y)
        
        // Disable interaction during animation
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        // Slide the views by -offset
                        fromView.center = CGPoint(x: fromView.center.x - offset, y: fromView.center.y)
                        toView.center = CGPoint(x: toView.center.x - offset, y: toView.center.y)
                        
        }, completion: { finished in
            // Remove the old view from the tabbar view.
            fromView.removeFromSuperview()
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        })
    }

}
