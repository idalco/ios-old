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
import DCKit

class JobTabVC: TabmanViewController, PageboyViewControllerDataSource {
   
    @IBOutlet weak var supportButton: UIButton!
    
    @IBOutlet weak var tabHolder: UIView!
    
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
        
        self.bar.items = [Item(title: "Requests"), Item(title: "Upcoming"), Item(title: "History")]
        
        self.bar.style = .scrollingButtonBar
        
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            // customize appearance here
            appearance.text.font = UIFont(name: "Montserrat-Medium", size: 16)
            appearance.indicator.color = UIColor.FindaColours.White
            appearance.state.selectedColor = UIColor.FindaColours.White
            appearance.state.color = UIColor.FindaColours.LightGrey
            appearance.style.background = .solid(color: UIColor.FindaColours.Burgundy)
            appearance.layout.itemDistribution = .centered
        })
        
        self.dataSource = self

    }
    
    
    func scrollToIndex(indexOf:Int) {
        scrollToPage(.at(index: indexOf), animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateNotificationCount()
        navigationItem.title = "JOBS"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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

extension UILabel {
    func textHeight(withWidth width: CGFloat) -> CGFloat {
        guard let text = text else {
            return 0
        }
        return text.height(withWidth: width, font: font)
    }
    
    func attributedTextHeight(withWidth width: CGFloat) -> CGFloat {
        guard let attributedText = attributedText else {
            return 0
        }
        return attributedText.height(withWidth: width)
    }
}

extension String {
    func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil)
        return actualSize.height
    }
}
extension NSAttributedString {
    func height(withWidth width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)
        return actualSize.height
    }
}

extension Array {
    mutating func rotate(positions: Int, size: Int? = nil) {
        guard positions < count && (size ?? 0) <= count else {
            print("invalid input")
            return
        }
        reversed(start: 0, end: positions - 1)
        reversed(start: positions, end: (size ?? count) - 1)
        reversed(start: 0, end: (size ?? count) - 1)
    }
    mutating func reversed(start: Int, end: Int) {
        guard start >= 0 && end < count && start < end else {
            return
        }
        var start = start
        var end = end
        while start < end, start != end {
            swap(&self[start], &self[end])
            start += 1
            end -= 1
        }
    }
}


extension UIView {
    
    func hideAnimated(in stackView: UIStackView) {
        if !self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = true
                    stackView.layoutIfNeeded()
            },
                completion: nil
            )
        }
    }
    
    func showAnimated(in stackView: UIStackView) {
        if self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = false
                    stackView.layoutIfNeeded()
            },
                completion: nil
            )
        }
    }
}


extension UIView{
    func animShow(offset: CGFloat, speed: TimeInterval) {
        UIView.animate(withDuration: speed, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= (self.bounds.height - offset)
                        self.layoutIfNeeded()
        }, completion: nil)
    }
    func animHide(offset: CGFloat, speed: TimeInterval) {
        UIView.animate(withDuration: speed, delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.center.y += (self.bounds.height - offset)
                        self.layoutIfNeeded()
        },  completion: nil)
    }
}
