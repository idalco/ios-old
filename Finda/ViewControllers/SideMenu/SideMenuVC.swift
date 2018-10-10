//
//  SideMenuVC.swift
//  Finda
//
//  Created by Peter Lloyd on 27/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import AlamofireImage
import Font_Awesome_Swift

class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var menu: [String] = []
    var icon: [FAType] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.view.backgroundColor = UIColor.FindaColours.White
        
        
        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "Settings") }, with: "Settings")
        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") }, with: "MainTabBar")
        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "PaymentNav") }, with: "PaymentNav")
        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "InviteNav") }, with: "InviteNav")
        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "InvoiceNav") }, with: "InvoiceNav")
        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "VerificationNav") }, with: "VerificationNav")
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        let modelManager = ModelManager()
        
        
        self.profileImage.setRounded()
        
        self.updateProfileImage()
        LoginManager.getDetails { (response, result) in
            if response {
                self.updateProfileImage()
            }
        }
        
        
    
        if modelManager.status() == UserStatus.unverified {
            self.menu = ["My Details", "Verification", "Invite a Friend", "Sign Out"]
            self.icon = [.FAUser, .FAClipboard, .FAUsers, .FAPowerOff]
        } else {
            self.menu = ["My Details", "Portfolio", "Polaroids", "Jobs", "Updates", "Payments", "Invite a Friend", "Sign Out"]
            self.icon = [.FAUser,  .FAImage, .FACameraRetro, .FACamera, .FAEnvelope, .FABank ,.FAUsers, .FAPowerOff]
        }
        self.tableView.reloadData()
        dismissKeyboard()
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
        
        cell.label.setFAText(prefixText: "", icon: self.icon[indexPath.row], postfixText: "   \(self.menu[indexPath.row])", size: 16.0, iconSize: 16.0)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let modelManager = ModelManager()
        var isVerified = true;
        if modelManager.kycOn() == -1 || modelManager.kycBy() == -1 || modelManager.kycOn() == 0 || modelManager.kycBy() == 0 {
            isVerified = false;
        }

        
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            LoginManager.signOut()
        } else if indexPath.row == tableView.numberOfRows(inSection: 0) - 2 {
            sideMenuController?.setContentViewController(with: "InviteNav")
            
        } else if indexPath.row == 0 {
            sideMenuController?.setContentViewController(with: "Settings")
            
        } else if indexPath.row == 1 {
            if !isVerified {
                sideMenuController?.setContentViewController(with: "VerificationNav")
            } else {
                sideMenuController?.setContentViewController(with: "MainTabBar")
                (sideMenuController?.contentViewController as? UITabBarController)?.selectedIndex = 2
                (((sideMenuController?.contentViewController as? UITabBarController)?.selectedViewController)?.childViewControllers[0] as? PhotoTabVC)?.scrollToPage(.first, animated: true)

            }
        } else if  indexPath.row == 2 {
            sideMenuController?.setContentViewController(with: "MainTabBar")
            (sideMenuController?.contentViewController as? UITabBarController)?.selectedIndex = 2
            (((sideMenuController?.contentViewController as? UITabBarController)?.selectedViewController)?.childViewControllers[0] as? PhotoTabVC)?.scrollToPage(.last, animated: true)
            
        } else if  indexPath.row == 3 {
            sideMenuController?.setContentViewController(with: "MainTabBar")
            (sideMenuController?.contentViewController as? UITabBarController)?.selectedIndex = 0
            
        } else if  indexPath.row == 4 {
            sideMenuController?.setContentViewController(with: "MainTabBar")
            (sideMenuController?.contentViewController as? UITabBarController)?.selectedIndex = 1
            
        } else if indexPath.row == 5 {
            if modelManager.bankAccountName().isEmpty || modelManager.bankSortcode().isEmpty || modelManager.bankAccountNumber().isEmpty {
                sideMenuController?.setContentViewController(with: "PaymentNav")
           } else if !isVerified {
                sideMenuController?.setContentViewController(with: "VerificationNav")
            } else {
                sideMenuController?.setContentViewController(with: "InvoiceNav")
            }
            
        }  else {
            
        }
        
        sideMenuController?.hideMenu()
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
