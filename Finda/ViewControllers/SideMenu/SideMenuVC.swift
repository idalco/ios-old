//
//  SideMenuVC.swift
//  Finda
//
//  Created by Peter Lloyd on 27/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import AlamofireImage
import Firebase
import SafariServices

class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var menu: [String] = []
    var icon: [NSMutableAttributedString] = []
   
    enum MenuType: Int {
        case loggedOut = 0
        case loggedIn = 1
        case needsVerification = 2
    }
    
    enum TabEntries: Int {
        case JobsTab = 0
        case CalendarTab = 1
        case UpdatesTab = 2
        case PhotosTab = 3
    }
    
    var menutype: MenuType = MenuType.loggedOut
    
    var segueIdentifier: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.view.backgroundColor = UIColor.FindaColours.White
        
        let preferences = UserDefaults.standard
        
        let currentLevelKey = "segueIdentifier"
        
        if preferences.object(forKey: currentLevelKey) == nil {
            //  Doesn't exist
            self.segueIdentifier = ""
        } else {
            self.segueIdentifier = preferences.string(forKey: currentLevelKey) ?? ""
        }
        
        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "Settings") }, with: "Settings")
        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") }, with: "MainTabBar")
        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "PaymentNav") }, with: "PaymentNav")
        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "InviteNav") }, with: "InviteNav")
        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "InvoiceNav") }, with: "InvoiceNav")
        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "VerificationNav") }, with: "VerificationNav")
//        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "Affiliates") }, with: "Affiliates")
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData , object: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        let modelManager = ModelManager()
        
        if modelManager.status() == UserStatus.unverified {

            self.menu = ["My Details",
                         "Portfolio",
                         "Polaroids",
                         "Verification",
                         "Sign Out"]
            
            let userIcon = NSMutableAttributedString(string: "")
            let imageIcon = NSMutableAttributedString(string: "")
            let cameraRetroIcon = NSMutableAttributedString(string: "")
            let clipboardIcon = NSMutableAttributedString(string: "")
            let powerOffIcon = NSMutableAttributedString(string: "")
            
            if let fafont = UIFont(name: "FontAwesome5FreeSolid", size: 15) {
                userIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                userIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))
                
                imageIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                imageIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))
                
                cameraRetroIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                cameraRetroIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))
                
                clipboardIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                clipboardIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))
                
                powerOffIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                powerOffIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))
                
            }
            
            self.icon = [userIcon,
                         imageIcon,
                         cameraRetroIcon,
                         clipboardIcon,
                         powerOffIcon
            ]
            self.menutype = MenuType.needsVerification
        } else {

            self.menu = ["My Details",
                         "Portfolio",
                         "Polaroids",
                         "Jobs",
                         "Updates",
                         "Payments",
                         "Calendar",
                         "FindaVoices",
                         "Podcast",
                         "FAQ",
//                         "Affiliates",
                         "Sign Out"]
            
            let userIcon = NSMutableAttributedString(string: "")
            let imageIcon = NSMutableAttributedString(string: "")
            let cameraRetroIcon = NSMutableAttributedString(string: "")
            let cameraIcon = NSMutableAttributedString(string: "")
            let commentDotsIcon = NSMutableAttributedString(string: "")
            let universityIcon = NSMutableAttributedString(string: "")
            let calendarIcon = NSMutableAttributedString(string: "")
            let heartIcon = NSMutableAttributedString(string: "")
            let questionIcon = NSMutableAttributedString(string: "")
            let powerOffIcon = NSMutableAttributedString(string: "")
            let podcastIcon = NSMutableAttributedString(string: "")
//            let shareIcon = NSMutableAttributedString(string: "")
            
            if let fafont = UIFont(name: "FontAwesome5FreeSolid", size: 15) {
                userIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                userIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))

                imageIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                imageIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))

                cameraRetroIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                cameraRetroIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))

                cameraIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                cameraIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))

                commentDotsIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                commentDotsIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))

                universityIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                universityIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))

                calendarIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                calendarIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))

                heartIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                heartIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))

                questionIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                questionIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))

                powerOffIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                powerOffIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))
                
                podcastIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
                podcastIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))

//                shareIcon.addAttribute(.font, value: fafont, range: NSMakeRange(0, 1))
//                shareIcon.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1), range: NSMakeRange(0, 1))

            }
            
            self.icon = [userIcon,
                         imageIcon,
                         cameraRetroIcon,
                        cameraIcon,
                        commentDotsIcon,
                        universityIcon,
                        calendarIcon,
                        heartIcon,
                        podcastIcon,
                        questionIcon,
//                        shareIcon,
                        powerOffIcon
            ]
            
            self.menutype = MenuType.loggedIn
        }
        
        self.tableView.reloadData()
        dismissKeyboard()
        
        if self.segueIdentifier != "" {
            if self.segueIdentifier == "editProfileSegue" {
                sideMenuController?.setContentViewController(with: "Settings")
                self.segueIdentifier = ""
            }
        }
        
    }
    
    private func updateProfileImage(){
        let modelManager = ModelManager()
        if modelManager.avatar() != "/default_profile.png" {
            if let imageUrl = URL(string: modelManager.avatar()) {
                self.profileImage.af_setImage(withAvatarURL: imageUrl, imageTransition: .crossDissolve(0.2))
            }
        } else if modelManager.filename() != "" {
            if let imageUrl = URL(string: modelManager.filename()) {
                self.profileImage.af_setImage(withPortfolioURL: imageUrl, imageTransition: .crossDissolve(0.2))
            }
        } else {
            if let imageUrl = URL(string: modelManager.avatar()){
                self.profileImage.af_setImage(withAvatarURL: imageUrl, imageTransition: .crossDissolve(0.2))
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.menu.count > 0 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.menu.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! SideMenuCell
        
        let cellTitle = self.icon[indexPath.row]
        let menuLabel = NSAttributedString(string: "  \(self.menu[indexPath.row])")
        cellTitle.append(menuLabel)
        
        cell.label.attributedText = cellTitle
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let modelManager = ModelManager()
        
        let smc = sideMenuController
        
        // @TODO redo this based on verified/unverified menus
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            LoginManager.signOut()
        } else {
            switch self.menutype {
                case MenuType.loggedOut:
                    switch indexPath.row {
                        default:
                            break
                        }
                    break
                case MenuType.loggedIn:
                    switch indexPath.row {
                        case 0:
                            sideMenuController?.setContentViewController(with: "Settings", animated: true)
                            break
                        case 1:
                            smc?.setContentViewController(with: "MainTabBar")
                            (smc?.contentViewController as? UITabBarController)?.selectedIndex = TabEntries.PhotosTab.rawValue
                            (((smc?.contentViewController as? UITabBarController)?.selectedViewController)?.children[0] as? PhotoTabVC)?.scrollToPage(.first, animated: true)
                            break
                        case 2:
                            smc?.setContentViewController(with: "MainTabBar")
                            (smc?.contentViewController as? UITabBarController)?.selectedIndex = TabEntries.PhotosTab.rawValue
                            (((smc?.contentViewController as? UITabBarController)?.selectedViewController)?.children[0] as? PhotoTabVC)?.scrollToPage(.last, animated: true)
                            break
                        case 3:
                            sideMenuController?.setContentViewController(with: "MainTabBar", animated: true)
                            (sideMenuController?.contentViewController as? UITabBarController)?.selectedIndex = TabEntries.JobsTab.rawValue
                            break
                        case 4:
                            sideMenuController?.setContentViewController(with: "MainTabBar", animated: true)
                            (sideMenuController?.contentViewController as? UITabBarController)?.selectedIndex = TabEntries.UpdatesTab.rawValue
                            break
                        case 5:
                            if modelManager.bankAccountName().isEmpty || modelManager.bankSortcode().isEmpty || modelManager.bankAccountNumber().isEmpty {
                                sideMenuController?.setContentViewController(with: "PaymentNav")
                            } else {
                                sideMenuController?.setContentViewController(with: "InvoiceNav")
                            }
                            break
                        case 6:
                            sideMenuController?.setContentViewController(with: "MainTabBar", animated: true)
                            (sideMenuController?.contentViewController as? UITabBarController)?.selectedIndex = TabEntries.CalendarTab.rawValue
                            break
                        case 7:
                            if let destination = NSURL(string: "https://www.facebook.com/groups/finda.co/") {
                                let safari = SFSafariViewController(url: destination as URL)
                                self.present(safari, animated: true)
                            }
                            break
                        case 8: // podcast
                            if let destination = NSURL(string: "https://podcasts.apple.com/gb/podcast/finda-voices-podcast/id1470088105") {
                                let safari = SFSafariViewController(url: destination as URL)
                                self.present(safari, animated: true)
                            }
                            break
                        case 9:
                            if let destination = NSURL(string: domainURL + "/faq/models") {
                                let safari = SFSafariViewController(url: destination as URL)
                                self.present(safari, animated: true)
                            }
                            break
//                        case 10:
//                            sideMenuController?.setContentViewController(with: "Affiliates", animated: true)
//                            break
                        default:
                            break
                    }
                    break
                case MenuType.needsVerification:
                    switch indexPath.row {
                        case 0:
                            sideMenuController?.setContentViewController(with: "Settings", animated: true)
                            break
                        case 1:
                            smc?.setContentViewController(with: "MainTabBar")
                            (smc?.contentViewController as? UITabBarController)?.selectedIndex = 2
                            (((smc?.contentViewController as? UITabBarController)?.selectedViewController)?.children[0] as? PhotoTabVC)?.scrollToPage(.first, animated: true)
                            break
                        case 2:
                            smc?.setContentViewController(with: "MainTabBar")
                            (smc?.contentViewController as? UITabBarController)?.selectedIndex = 2
                            (((smc?.contentViewController as? UITabBarController)?.selectedViewController)?.children[0] as? PhotoTabVC)?.scrollToPage(.last, animated: true)
                            break
                        case 3:
                            sideMenuController?.setContentViewController(with: "VerificationNav", animated: true)
                            break
                        default:
                            break
                    }
                    break
            }
        }
        
        sideMenuController?.hideMenu()
    }
    
    @objc func onDidReceiveData(_ notification: NSNotification) {
        
        if let data = notification.userInfo as? [String: Any] {
            (sideMenuController?.contentViewController as? UITabBarController)?.tabBar.items?[0].badgeValue = data["jobscount"] as? String
            (sideMenuController?.contentViewController as? UITabBarController)?.tabBar.items?[2].badgeValue = data["msgcount"] as? String
        }
        
    }

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
        

     }


}
