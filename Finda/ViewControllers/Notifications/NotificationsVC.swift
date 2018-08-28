//
//  NotificationsVC.swift
//  Finda
//
//  Created by Peter Lloyd on 06/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var allNotifications: [Notification] = []
//    var readNotifications: [Notification] = []
//    var newNotifications: [Notification] = []
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.navigationController?.navigationBar.transparentNavigationBar()
        self.messageView.backgroundColor = UIColor.FindaColors.Purple
        self.messageLabel.textColor = UIColor.FindaColors.White
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadNotifications()
    }
    
    @IBAction func showMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    private func updateNotificationCount(){
        NotificationManager.countNotifications(notificationType: .new) { (response, result) in
            if response {
                self.tabBarController?.tabBar.items?[1].badgeValue = result["userdata"].string
            }
        }
    }
    
    private func setup() {
        if #available(iOS 10.0, *) {
            let refresh =  UIRefreshControl()
            refresh.tintColor = UIColor.black
            self.tableView.refreshControl = refresh
            
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    @objc func refreshHandler() {
        self.loadNotifications()
    }
    
    private func loadNotifications(){
        NotificationManager.getNotifications(notificationType: .all) { (response, result) in
            self.tableView.refreshControl?.endRefreshing()
            self.allNotifications.removeAll()
//            self.readNotifications.removeAll()
//            self.newNotifications.removeAll()

            if(response) {
                let notifications = result["userdata"].arrayValue
                print("notification test")
                print(notifications)

                for notification in notifications {
                    
                    let notificationObject: Notification = Notification(data: notification)
//                    if notificationObject.status == Notification.Status.New.rawValue {
//                        self.newNotifications.append(notificationObject)
//                    } else {
//                        self.readNotifications.append(notificationObject)
//                    }
                    self.allNotifications.append(notificationObject)
                }
                if self.allNotifications.count > 0 {
                    self.tableView.isHidden = false
                    self.messageLabel.text = "Notifications"
                } else {
                    self.tableView.isHidden = true
                    self.messageLabel.text = "Currently you have no notifications"
                }
                self.tableView.reloadData()
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
//        if self.newNotifications.isEmpty && self.readNotifications.isEmpty { return 0}
//        if self.newNotifications.isEmpty { return 1 }
        return self.allNotifications.count > 0 ? 1 : 0
    }
    
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.font = UIFont(name: "Gotham-Medium", size: 16)!
////        header.backgroundView?.backgroundColor = UIColor.FindaColors.Purple.lighter(by: 80)
//    }
//


//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if !self.newNotifications.isEmpty && section == 0 {
//            return "New notifications"
//        }
//        return "Read notifications"
//
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        if !self.newNotifications.isEmpty && section == 0 {
//            return self.newNotifications.count
//        }
//        return self.readNotifications.count
        return self.allNotifications.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationCell
        
        cell.nameLabel.text = "\(allNotifications[indexPath.row].firstname) \(allNotifications[indexPath.row].lastname)"
        cell.dateLabel.text = Date().displayDate(timeInterval: allNotifications[indexPath.row].timestamp, format:  "MMM dd, yyyy")
        cell.messageLabel.attributedText = allNotifications[indexPath.row].message.htmlAttributed(family: "Gotham-Light")
        
      
        let linkAttributes: [String : Any] = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.FindaColors.Purple,
//            NSAttributedStringKey.underlineColor.rawValue: UIColor.FindaColors.Yellow,
//            NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleNone.rawValue
        ]
        
        cell.messageLabel.linkTextAttributes = linkAttributes
    
        
        
        if allNotifications[indexPath.row].status == Notification.Status.New.rawValue {
            cell.backgroundColor = UIColor.FindaColors.Purple.fade()
        }
        
        return cell
    }


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let notificationId = allNotifications[indexPath.row].id
            NotificationManager.deleteNotifications(id: notificationId)
            allNotifications.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.tabBarController?.selectedIndex = 0
    }

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
