//
//  HomePageVC.swift
//  Finda
//
//  Created by cro on 04/07/2019.
//  Copyright © 2019 Finda Ltd. All rights reserved.
//

import Foundation
import DCKit

class HomePageVC: UIViewController {

    @IBOutlet weak var referrerCode: UIButton!
    @IBOutlet weak var referralCode: UIButton!
    
    @IBOutlet weak var supportButton: UIBarButtonItem!
    
    @IBOutlet weak var availabilityPanel: UIView!
    
    @IBOutlet weak var showHideAvailabilityButton: UILabel!
    
    @IBOutlet weak var tomorrowButton: DCRoundedButton!
    @IBOutlet weak var tomorrowLabel: UILabel!
    
    @IBOutlet weak var dayTwoButton: DCRoundedButton!
    @IBOutlet weak var dayTwoLabel: UILabel!
    
    @IBOutlet weak var dayThreeButton: DCRoundedButton!
    @IBOutlet weak var dayThreeLabel: UILabel!
    
    @IBOutlet weak var dayFourButton: DCRoundedButton!
    
    @IBOutlet weak var dayFourLabel: UILabel!
    
    @IBOutlet weak var dayFiveButton: DCRoundedButton!
    @IBOutlet weak var dayFiveLabel: UILabel!
    
    @IBOutlet weak var daySixButton: DCRoundedButton!
    @IBOutlet weak var daySixLabel: UILabel!
    
    var weekdays: [String] = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    
    var availability: [String : Int] = ["monday" : 0, "tuesday" : 0, "wednesday" : 0, "thursday" : 0, "friday" : 0, "saturday" : 0, "sunday" : 0]
    
    var availabilityPanelVisible: Bool = false
    var availabilityPanelOpenY: CGFloat = 0
    var availabilityPanelClosedY: CGFloat = 0
    
    var openTabHeight: CGFloat = 64
    var openSpeed: TimeInterval = 0.5
    
    let preferences = UserDefaults.standard
    let panelConstant = "panelConstant"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let modelManager = ModelManager()
        
        referrerCode.text("finda.co/\(modelManager.referrerCode())")
        referrerCode.addTarget(self, action: #selector(tapReferrerCode), for: .touchUpInside)
       
        referralCode.addTarget(self, action: #selector(tapReferralCode), for: .touchUpInside)
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(HomePageVC.showHideAvailabilityPanel))
        showHideAvailabilityButton.addGestureRecognizer(tapRec)
        showHideAvailabilityButton.isUserInteractionEnabled = true
        
        showHideAvailabilityPanel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "HOME"

        edgesForExtendedLayout = []
        
        openTabHeight = showHideAvailabilityButton.frame.height

        availabilityPanel.translatesAutoresizingMaskIntoConstraints = false

        availabilityPanel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        
        self.view.layoutIfNeeded()

        let tabbarHeight = self.tabBarController?.getHeight()
        let bottom = UIScreen.main.bounds.height
        let panelHeight = availabilityPanel.bounds.height
        let padding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        availabilityPanelOpenY = bottom - tabbarHeight! - panelHeight - padding + 14

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
        
        
    }

    @IBAction func menu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    @IBAction func support(_ send: Any) {
        let smc = sideMenuController
        smc?.setContentViewController(with: "SupportNav", animated: true)
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
        tomorrowLabel.textColor = UIColor.FindaColours.White
        
        attributes[.foregroundColor] = buttonColours[self.availability[self.weekdays[2]]!]
        attributedString = NSAttributedString(string: buttonText[self.availability[self.weekdays[2]]!],
                                              attributes: attributes)
        dayTwoButton.setAttributedTitle(attributedString, for: .normal)
        dayTwoButton.addTarget(self, action: #selector(didTapDayTwoButton), for: .touchUpInside)
        dayTwoLabel.text = self.weekdays[2].capitalizingFirstLetter()
        dayTwoLabel.textColor = UIColor.FindaColours.White
        
        attributes[.foregroundColor] = buttonColours[self.availability[self.weekdays[3]]!]
        attributedString = NSAttributedString(string: buttonText[self.availability[self.weekdays[3]]!],
                                              attributes: attributes)
        dayThreeButton.setAttributedTitle(attributedString, for: .normal)
        dayThreeButton.addTarget(self, action: #selector(didTapDayThreeButton), for: .touchUpInside)
        dayThreeLabel.text = self.weekdays[3].capitalizingFirstLetter()
        dayThreeLabel.textColor = UIColor.FindaColours.White
        
        attributes[.foregroundColor] = buttonColours[self.availability[self.weekdays[4]]!]
        attributedString = NSAttributedString(string: buttonText[self.availability[self.weekdays[4]]!],
                                              attributes: attributes)
        dayFourButton.setAttributedTitle(attributedString, for: .normal)
        dayFourButton.addTarget(self, action: #selector(didTapDayFourButton), for: .touchUpInside)
        dayFourLabel.text = self.weekdays[4].capitalizingFirstLetter()
        dayFourLabel.textColor = UIColor.FindaColours.White
        
        attributes[.foregroundColor] = buttonColours[self.availability[self.weekdays[5]]!]
        attributedString = NSAttributedString(string: buttonText[self.availability[self.weekdays[5]]!],
                                              attributes: attributes)
        dayFiveButton.setAttributedTitle(attributedString, for: .normal)
        dayFiveButton.addTarget(self, action: #selector(didTapDayFiveButton), for: .touchUpInside)
        dayFiveLabel.text = self.weekdays[5].capitalizingFirstLetter()
        dayFiveLabel.textColor = UIColor.FindaColours.White
        
        attributes[.foregroundColor] = buttonColours[self.availability[self.weekdays[6]]!]
        attributedString = NSAttributedString(string: buttonText[self.availability[self.weekdays[6]]!],
                                              attributes: attributes)
        daySixButton.setAttributedTitle(attributedString, for: .normal)
        daySixButton.addTarget(self, action: #selector(didTapDaySixButton), for: .touchUpInside)
        daySixLabel.text = self.weekdays[6].capitalizingFirstLetter()
        daySixLabel.textColor = UIColor.FindaColours.White
        
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
    
    @objc private func tapReferrerCode() {
        let modelManager = ModelManager()
        UIPasteboard.general.string = "https;//finda.co/\(modelManager.referrerCode())"
        let alert = UIAlertController(title: "", message: "Code copied to clipboard", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func tapReferralCode() {
            let smc = sideMenuController
        smc?.setContentViewController(with: "InviteNav", animated: true)
    }
    
    
    
    @objc func showHideAvailabilityPanel() {
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.font] = UIFont(name: "Font Awesome 5 Free", size: 17.0)
        attributes[.foregroundColor] = UIColor.FindaColours.White
        var attributedString = NSAttributedString(string: "", attributes: attributes)
        
        self.view.layoutIfNeeded()
        
        if (availabilityPanelVisible == true) {
            availabilityPanelOpenY = availabilityPanel.center.y
        } else {
            availabilityPanelClosedY = availabilityPanel.center.y
        }
        
        if availabilityPanelVisible {
            availabilityPanel.animHide(offset: openTabHeight + 10, speed: openSpeed)
            availabilityPanelVisible = false
            attributedString = NSAttributedString(string: "", attributes: attributes)
            showHideAvailabilityButton.attributedText = attributedString
            preferences.set("closed", forKey: panelConstant)
        } else {
            availabilityPanel.animShow(offset: openTabHeight + 10, speed: openSpeed)
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
    
    
    
    
    
}

extension UITabBarController{

    func getHeight()->CGFloat{
        return self.tabBar.frame.size.height
    }

    func getWidth()->CGFloat{
         return self.tabBar.frame.size.width
    }
}
