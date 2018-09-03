//
//  PreferencesTabBarController .swift
//  Finda
//
//  Created by Peter Lloyd on 31/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//
import UIKit

class PreferencesTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.tabBar.barTintColor = UIColor.FindaColors.Yellow
        self.tabBar.tintColor = UIColor.FindaColors.White
        self.tabBar.unselectedItemTintColor = UIColor.FindaColors.Black
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateToTab(toIndex: Int) {
        let tabViewControllers = viewControllers!
        let fromView = selectedViewController!.view
        let toView = tabViewControllers[toIndex].view
        let fromIndex = tabViewControllers.index(of: selectedViewController!)
        
        guard fromIndex != toIndex else {return}
        fromView?.superview?.addSubview(toView!)

        
        let screenWidth = UIScreen.main.bounds.size.width
        let scrollRight = toIndex > fromIndex!
        let offset = (scrollRight ? screenWidth : -screenWidth)
        toView?.center = CGPoint(x: (fromView?.center.x)! + offset, y: (toView?.center.y)!)
        

        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            

            fromView?.center = CGPoint(x: (fromView?.center.x)! - offset, y: (fromView?.center.y)!)
            toView?.center   = CGPoint(x: (toView?.center.x)! - offset, y: (toView?.center.y)!)
            
        }, completion: { finished in
            

            fromView?.removeFromSuperview()
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        })
    }
}

extension PreferencesTabBarController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        
        let tabViewControllers = tabBarController.viewControllers!
        
        guard let toIndex = tabViewControllers.index(of: viewController) else {
            return false
        }
        

        self.animateToTab(toIndex: toIndex)
        
        return true
    }
}

