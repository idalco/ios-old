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
    
    var weekdays: [String] = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    
    var availability: [String : Int] = ["monday" : 0, "tuesday" : 0, "wednesday" : 0, "thursday" : 0, "friday" : 0, "saturday" : 0, "sunday" : 0]
    
    @IBOutlet var tomorrowButton: DCRoundedButton!
    @IBOutlet var dayTwoButton: DCRoundedButton!
    @IBOutlet var dayTwoLabel: UILabel!
    @IBOutlet var dayThreeButton: DCRoundedButton!
    @IBOutlet var dayThreeLabel: UILabel!
    @IBOutlet var dayFourButton: DCRoundedButton!
    @IBOutlet var dayFourLabel: UILabel!
    @IBOutlet var dayFiveButton: DCRoundedButton!
    @IBOutlet var dayFiveLabel: UILabel!
    @IBOutlet var daySixButton: DCRoundedButton!
    @IBOutlet var daySixLabel: UILabel!
    
    @IBOutlet weak var availabilityPanel: UIView!
    @IBOutlet weak var showHideAvailabilityButton: UILabel!
    
    var availabilityPanelVisible: Bool = false
    var availabilityPanelOpenY: CGFloat = 0
    var availabilityPanelClosedY: CGFloat = 0
    
    var openTabHeight: CGFloat = 64
    var openSpeed: TimeInterval = 0.5
    
    let preferences = UserDefaults.standard
    let panelConstant = "panelConstant"
    
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
        
        self.bar.items = [Item(title: "Upcoming/Offers"), Item(title: "To Complete"), Item(title: "History")]
        
        self.bar.style = .scrollingButtonBar
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            // customize appearance here
            appearance.text.font = UIFont(name: "Gotham-Medium", size: 16)
            appearance.indicator.color = UIColor.FindaColours.Blue
            appearance.state.selectedColor = UIColor.FindaColours.Blue
        })
        self.dataSource = self

        let tapRec = UITapGestureRecognizer(target: self, action: #selector(JobTabVC.showHideAvailabilityPanel))
        showHideAvailabilityButton.addGestureRecognizer(tapRec)
        showHideAvailabilityButton.isUserInteractionEnabled = true
        
        showHideAvailabilityPanel()
        
        print("JobTabVC ViewDidLoad")
    }
    
    @objc func showHideAvailabilityPanel() {
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.font] = UIFont(name: "Font Awesome 5 Free", size: 17.0)
        attributes[.foregroundColor] = UIColor.FindaColours.Black
        var attributedString = NSAttributedString(string: "", attributes: attributes)
        
        self.view.layoutIfNeeded()
        
        if (availabilityPanelVisible == true) {
            availabilityPanelOpenY = availabilityPanel.center.y
        } else {
            availabilityPanelClosedY = availabilityPanel.center.y
        }
        
        if availabilityPanelVisible {
            availabilityPanel.animHide(offset: openTabHeight, speed: openSpeed)
            availabilityPanelVisible = false
            attributedString = NSAttributedString(string: "", attributes: attributes)
            showHideAvailabilityButton.attributedText = attributedString
            preferences.set("closed", forKey: panelConstant)
        } else {
            availabilityPanel.animShow(offset: openTabHeight, speed: openSpeed)
            availabilityPanelVisible = true
            
            attributedString = NSAttributedString(string: "", attributes: attributes)
            showHideAvailabilityButton.attributedText = attributedString
            preferences.set("open", forKey: panelConstant)
        }
        
        self.view.layoutIfNeeded()
        
        if (availabilityPanelVisible == true) {
            availabilityPanelOpenY = availabilityPanel.center.y
        } else {
            availabilityPanelClosedY = availabilityPanel.center.y
        }
    }
    
    func scrollToIndex(indexOf:Int) {
        scrollToPage(.at(index: indexOf), animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateNotificationCount()
        navigationItem.title = "Jobs"
        openTabHeight = showHideAvailabilityButton.frame.height

        availabilityPanel.translatesAutoresizingMaskIntoConstraints = false

        self.view.layoutIfNeeded()

        if preferences.object(forKey: panelConstant) != nil {
            let panelState = preferences.string(forKey: panelConstant)
            
            if panelState == "open" {
                availabilityPanelVisible = true
                availabilityPanel.center.y = availabilityPanelOpenY
            } else {
                availabilityPanelVisible = false
                availabilityPanel.center.y = availabilityPanelClosedY
            }
        }
        
        self.view.layoutIfNeeded()
        
        availabilityPanel.translatesAutoresizingMaskIntoConstraints = true
        
        self.setAvailabilityButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        availabilityPanelOpenY = availabilityPanel.center.y
    }
    
    private func updateNotificationCount() {
        NotificationManager.countNotifications(notificationType: .new) { (response, result) in
            if response {
                self.tabBarController?.tabBar.items?[2].badgeValue = result["userdata"].string
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
    
    /*
     * sets availability button actions and labels
     */
    private func setAvailabilityButtons() {
        
        FindaAPISession(target: .getLastMinute) { (response, result) in
            if response {
                for (day, availability) in result["availability"] {
                    self.availability[day] = availability.intValue
                }
                
                // now we reorder the array to shift it to today
                let position = self.weekdays.firstIndex(of: self.currentDayOfWeek())
                self.weekdays.rotate(positions: position!)
                
                self.setButtonInfo()

            }
        }
        
    }
    
    func cycleAvailabilityState(dayId: Int) {
        let weekday: String = self.weekdays[dayId]
        var avail: Int = self.availability[weekday]!
        avail += 1
        if avail > 2 {
            avail = 0
        }
        self.availability[weekday] = avail
        saveAvailability()
    }
    
    private func saveAvailability() {
        FindaAPISession(target: .setLastMinute(availability: self.availability)) { (response, result) in
            if response {
                self.setButtonInfo()
            }
        }
    }
    
    private func currentDayOfWeek() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        return dayInWeek.lowercased()
    }
    
    private func setButtonInfo() {
        
        let buttonText: [String] = ["", "", ""]
        let buttonColours: [UIColor] = [UIColor.FindaColours.White, UIColor.FindaColours.Pink, UIColor.FindaColours.Black]
        
        
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.font] = UIFont(name: "Font Awesome 5 Free", size: 24.0)
        attributes[.foregroundColor] = buttonColours[self.availability[self.weekdays[1]]!]
        
        var attributedString = NSAttributedString(string: buttonText[self.availability[self.weekdays[1]]!], attributes: attributes)
        
        tomorrowButton.setAttributedTitle(attributedString, for: .normal)
        tomorrowButton.addTarget(self, action: #selector(tapTomorrowButton), for: .touchUpInside)
        
        attributes[.foregroundColor] = buttonColours[self.availability[self.weekdays[2]]!]
        attributedString = NSAttributedString(string: buttonText[self.availability[self.weekdays[2]]!],
                                              attributes: attributes)
        dayTwoButton.setAttributedTitle(attributedString, for: .normal)
        dayTwoButton.addTarget(self, action: #selector(didTapDayTwoButton), for: .touchUpInside)
        dayTwoLabel.text = self.weekdays[2].capitalizingFirstLetter()
        
        attributes[.foregroundColor] = buttonColours[self.availability[self.weekdays[3]]!]
        attributedString = NSAttributedString(string: buttonText[self.availability[self.weekdays[3]]!],
                                              attributes: attributes)
        dayThreeButton.setAttributedTitle(attributedString, for: .normal)
        dayThreeButton.addTarget(self, action: #selector(didTapDayThreeButton), for: .touchUpInside)
        dayThreeLabel.text = self.weekdays[3].capitalizingFirstLetter()
        
        attributes[.foregroundColor] = buttonColours[self.availability[self.weekdays[4]]!]
        attributedString = NSAttributedString(string: buttonText[self.availability[self.weekdays[4]]!],
                                              attributes: attributes)
        dayFourButton.setAttributedTitle(attributedString, for: .normal)
        dayFourButton.addTarget(self, action: #selector(didTapDayFourButton), for: .touchUpInside)
        dayFourLabel.text = self.weekdays[4].capitalizingFirstLetter()
        
        attributes[.foregroundColor] = buttonColours[self.availability[self.weekdays[5]]!]
        attributedString = NSAttributedString(string: buttonText[self.availability[self.weekdays[5]]!],
                                              attributes: attributes)
        dayFiveButton.setAttributedTitle(attributedString, for: .normal)
        dayFiveButton.addTarget(self, action: #selector(didTapDayFiveButton), for: .touchUpInside)
        dayFiveLabel.text = self.weekdays[5].capitalizingFirstLetter()
        
        attributes[.foregroundColor] = buttonColours[self.availability[self.weekdays[6]]!]
        attributedString = NSAttributedString(string: buttonText[self.availability[self.weekdays[6]]!],
                                              attributes: attributes)
        daySixButton.setAttributedTitle(attributedString, for: .normal)
        daySixButton.addTarget(self, action: #selector(didTapDaySixButton), for: .touchUpInside)
        daySixLabel.text = self.weekdays[6].capitalizingFirstLetter()
        
        
    }
    
    // button actions
    // the slow way
    @objc private func tapTomorrowButton() {
        cycleAvailabilityState(dayId: 1)
    }
    @objc private func didTapDayTwoButton() {
        cycleAvailabilityState(dayId: 2)
    }
    @objc private func didTapDayThreeButton() {
        cycleAvailabilityState(dayId: 3)
    }
    @objc private func didTapDayFourButton() {
        cycleAvailabilityState(dayId: 4)
    }
    @objc private func didTapDayFiveButton() {
        cycleAvailabilityState(dayId: 5)
    }
    @objc private func didTapDaySixButton() {
        cycleAvailabilityState(dayId: 6)
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
            print("invalid input1")
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
