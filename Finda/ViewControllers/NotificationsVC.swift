//
//  NotificationsVC.swift
//  Finda
//
//  Created by Peter Lloyd on 06/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit

class NotificationsVC: UITableViewController {

    var allNotifications: [Notification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadNotifications()
        self.updateNotificationCount()
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
            if(response) {
                let notifications = result["userdata"].dictionaryValue

                for notification in notifications {
                    self.allNotifications.append(Notification(data: notification.value))
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.allNotifications.count > 0 ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.allNotifications.count
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationCell

        cell.nameLabel.text = "\(allNotifications[indexPath.row].firstname) \(allNotifications[indexPath.row].lastname)"
        cell.dateLabel.text = Date().displayDate(timeInterval: allNotifications[indexPath.row].timestamp, format:  "MMM dd, yyyy")
        cell.messageLabel.attributedText = allNotifications[indexPath.row].message.htmlAttributed(family: "Gotham-Light")
        return cell
    }


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let notificationId = allNotifications[indexPath.row].id
            NotificationManager.deleteNotifications(id: notificationId)
            allNotifications.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabBarController?.selectedIndex = 0
//        self.performSegue(withIdentifier: "jobSegue", sender: nil)
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
