//
//  SideMenuVC.swift
//  Finda
//
//  Created by Peter Lloyd on 27/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import AlamofireImage
import FontAwesome_swift
import Firebase
import SafariServices

class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var menu: [String] = []
    var icon: [String] = []
   
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
//        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "Calendar") }, with: "Calendar")

//        NotificationCenter.default.addObserver(self, selector: #selector(self.displayFCMToken(notification:)), name: NSNotification.Name(rawValue: "FCMToken"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData , object: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        let modelManager = ModelManager()
        
//        self.profileImage.setRounded()
//        self.updateProfileImage()
//        LoginManager.getDetails { (response, result) in
//            if response {
//                self.updateProfileImage()
//            }
//        }
        
        if modelManager.status() == UserStatus.unverified {

            self.menu = ["My Details",
                         "Portfolio",
                         "Polaroids",
                         "Verification",
                         "Sign Out"]
            self.icon = [String.fontAwesomeIcon(name: .user),
                         String.fontAwesomeIcon(name: .image),
                         String.fontAwesomeIcon(name: .cameraRetro),
                         String.fontAwesomeIcon(name: .clipboard),
                         String.fontAwesomeIcon(name: .powerOff)
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
                         "FAQ",
                         "Sign Out"]
            self.icon = [String.fontAwesomeIcon(name: .user),
                         String.fontAwesomeIcon(name: .image),
                         String.fontAwesomeIcon(name: .cameraRetro),
                         String.fontAwesomeIcon(name: .camera),
                         String.fontAwesomeIcon(name: .commentDots),
                         String.fontAwesomeIcon(name: .university),
                         String.fontAwesomeIcon(name: .calendar),
                         String.fontAwesomeIcon(name: .heart),
                         String.fontAwesomeIcon(name: .question),
                         String.fontAwesomeIcon(name: .powerOff)]
            
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
            if let imageUrl = URL(string: modelManager.avatar()){
                self.profileImage.af_setImage(withAvatarURL: imageUrl, imageTransition: .crossDissolve(0.2))
            }
        } else if modelManager.filename() != "" {
            if let imageUrl = URL(string: modelManager.filename()){
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
        
        let FAAttribute = [ NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: 16.0, style: .solid) ]
        let cellTitle = NSMutableAttributedString(string: "\(self.icon[indexPath.row])", attributes: FAAttribute )
        
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
//                            sideMenuController?.setContentViewController(with: "Calendar", animated: true)
                            break
//                        case 6:
                        case 7:
                            if let destination = NSURL(string: "https://www.facebook.com/groups/finda.co/") {
                                let safari = SFSafariViewController(url: destination as URL)
                                self.present(safari, animated: true)
                            }
                            break
//                        case 7:
                        case 8:
                            if let destination = NSURL(string: domainURL + "/faq/model") {
                                let safari = SFSafariViewController(url: destination as URL)
                                self.present(safari, animated: true)
                            }
                            break
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
        

        
        
        
        
        
        
//        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
//            LoginManager.signOut()
//
//        } else if indexPath.row == tableView.numberOfRows(inSection: 0) - 2 {
//            if self.menutype == MenuType.needsVerification {
//                sideMenuController?.setContentViewController(with: "VerificationNav", animated: true)
//            } else {
//
//                if let destination = NSURL(string: domainURL + "/faq/model") {
//                    let safari = SFSafariViewController(url: destination as URL)
//                    self.present(safari, animated: true)
//                }
//            }
//        } else if indexPath.row == tableView.numberOfRows(inSection: 0) - 3 {
//            if let destination = NSURL(string: "https://www.facebook.com/groups/finda.co/") {
//                let safari = SFSafariViewController(url: destination as URL)
//                self.present(safari, animated: true)
//            }
//
////        } else if indexPath.row == tableView.numberOfRows(inSection: 0) - 4 {
////            sideMenuController?.setContentViewController(with: "InviteNav", animated: true)
//
//        } else if indexPath.row == 0 {
//            sideMenuController?.setContentViewController(with: "Settings", animated: true)
//
//        } else if indexPath.row == 1 {
//
//            smc?.setContentViewController(with: "MainTabBar")
//            (smc?.contentViewController as? UITabBarController)?.selectedIndex = 2
//            (((smc?.contentViewController as? UITabBarController)?.selectedViewController)?.children[0] as? PhotoTabVC)?.scrollToPage(.first, animated: true)
//
//        } else if  indexPath.row == 2 {
//            smc?.setContentViewController(with: "MainTabBar")
//            (smc?.contentViewController as? UITabBarController)?.selectedIndex = 2
//            (((smc?.contentViewController as? UITabBarController)?.selectedViewController)?.children[0] as? PhotoTabVC)?.scrollToPage(.last, animated: true)
//
//        } else if  indexPath.row == 3 {
//            if self.menutype == MenuType.needsVerification {
//                sideMenuController?.setContentViewController(with: "VerificationNav", animated: true)
//            } else {
//                sideMenuController?.setContentViewController(with: "MainTabBar", animated: true)
//                (sideMenuController?.contentViewController as? UITabBarController)?.selectedIndex = 0
//            }
//        } else if  indexPath.row == 4 {
//            sideMenuController?.setContentViewController(with: "MainTabBar", animated: true)
//            (sideMenuController?.contentViewController as? UITabBarController)?.selectedIndex = 1
//
//        } else if indexPath.row == 5 {
//            if modelManager.bankAccountName().isEmpty || modelManager.bankSortcode().isEmpty || modelManager.bankAccountNumber().isEmpty {
//                sideMenuController?.setContentViewController(with: "PaymentNav")
//           } else if !isVerified {
//                sideMenuController?.setContentViewController(with: "VerificationNav")
//            } else {
//                sideMenuController?.setContentViewController(with: "InvoiceNav")
//            }
//
//        }  else {
//
//        }
        
        sideMenuController?.hideMenu()
    }
    
    @objc func onDidReceiveData(_ notification: NSNotification) {
        
        if let data = notification.userInfo as? [String: Any] {
            (sideMenuController?.contentViewController as? UITabBarController)?.tabBar.items?[0].badgeValue = data["jobscount"] as? String
            (sideMenuController?.contentViewController as? UITabBarController)?.tabBar.items?[2].badgeValue = data["msgcount"] as? String
        }
        
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        

//     }
    
    
    //    @objc func displayFCMToken(notification: NSNotification) {
    //
    //        print("Display notification: starting")
    //
    //        guard let userInfo = notification.userInfo else {return}
    //        print("Display notification: got userInfo")
    //        print(userInfo)
    //
    //        guard
    //            let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
    //            let alert = aps["alert"] as? NSString
    //        else {
    //                return
    //        }
    //        print("Display notification: got data")
    //        print(aps)
    //        print(alert)
    //
    //        let alertController = UIAlertController(title: "Push Notification", message: "\(alert)", preferredStyle: UIAlertControllerStyle.alert)
    //        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
    //
    //        self.present(alertController, animated: true, completion: nil)
    //
    //    }
}
