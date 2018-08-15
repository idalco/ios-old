//
//  SideMenuVC.swift
//  Finda
//
//  Created by Peter Lloyd on 27/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import AlamofireImage

class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    //"Payments", "Invite a Friend",
    let menu = ["My Details", "Portfolio", "Polaroids", "Jobs", "Notifications", "Sign Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.view.backgroundColor = UIColor.FindaColors.White
        let modelManager = ModelManager()
        self.profileImage.setRounded()
        if let imageUrl = URL(string: modelManager.avatar()){
            self.profileImage.af_setImage(withURL: imageUrl)
        }
        
        sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "PersonalDetailsNav") }, with: "0")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if menu.count > 0 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menu.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! SideMenuCell
        cell.label.text = menu[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            LoginManager.signOut()
        } else if  indexPath.row == 1 {

            (sideMenuController?.contentViewController as? UITabBarController)?.selectedIndex = 2
            sideMenuController?.hideMenu()
            
        } else if  indexPath.row == 2 {
            
            (sideMenuController?.contentViewController as? UITabBarController)?.selectedIndex = 2
            sideMenuController?.hideMenu()
            // Scroll to Polaroids
//            print((sideMenuController?.contentViewController as? UITabBarController)?.selectedViewController)


            
        } else if  indexPath.row == 3 {
            
            (sideMenuController?.contentViewController as? UITabBarController)?.selectedIndex = 0
            sideMenuController?.hideMenu()
            
        } else if  indexPath.row == 4 {
            
            (sideMenuController?.contentViewController as? UITabBarController)?.selectedIndex = 1
            sideMenuController?.hideMenu()
            
        }else {
            sideMenuController?.hideMenu()
            sideMenuController?.setContentViewController(with: "\(indexPath.row)")
            
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
