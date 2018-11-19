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
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.navigationController?.navigationBar.transparentNavigationBar()
        self.messageView.backgroundColor = UIColor.FindaColours.Blue
        self.messageLabel.textColor = UIColor.FindaColours.White
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

            if (response) {
                let notifications = result["userdata"].arrayValue

                for notification in notifications {
                    
                    let notificationObject: Notification = Notification(data: notification)
                    self.allNotifications.append(notificationObject)
                }
                if self.allNotifications.count > 0 {
                    self.tableView.isHidden = false
                    self.messageLabel.text = "Updates"
                } else {
                    self.tableView.isHidden = true
                    self.messageLabel.text = "Currently you have no updates"
                }
                self.tableView.reloadData()
            } else {
                self.tableView.isHidden = true
                self.messageLabel.text = "Currently you have no updates"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
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
        return self.allNotifications.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.jobAction (_:)))
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationCell

//        cell.addGestureRecognizer(gesture)

        cell.nameLabel.text = "\(allNotifications[indexPath.row].firstname) \(allNotifications[indexPath.row].lastname)"
        cell.dateLabel.text = Date().displayDate(timeInterval: allNotifications[indexPath.row].timestamp, format:  "MMM dd, yyyy")
        cell.messageLabel.attributedText = allNotifications[indexPath.row].message.htmlAttributed(family: "Gotham-Light")
        
        // set avatar here
        cell.messageAvatar.setRounded(colour: UIColor.FindaColours.Blue.cgColor)
//        cell.messageAvatar.af_setImage(withAvatarURL: imageUrl, imageTransition: .crossDissolve(0.2))
        
        if allNotifications[indexPath.row].avatar != "/default_profile.png" {
            if let imageUrl = URL(string: allNotifications[indexPath.row].avatar){
                cell.messageAvatar.af_setImage(withAvatarURL: imageUrl, imageTransition: .crossDissolve(0.2))
            }
        } else if allNotifications[indexPath.row].avatar != "" {
            if let imageUrl = URL(string: allNotifications[indexPath.row].avatar){
                cell.messageAvatar.af_setImage(withPortfolioURL: imageUrl, imageTransition: .crossDissolve(0.2))
            }
        } else {
            if let imageUrl = URL(string: allNotifications[indexPath.row].avatar){
                cell.messageAvatar.af_setImage(withAvatarURL: imageUrl, imageTransition: .crossDissolve(0.2))
            }
        }
        
        let linkAttributes: [String : Any] = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.FindaColours.Black,
            NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleNone.rawValue,
            NSAttributedStringKey.underlineColor.rawValue: UIColor.FindaColours.White,
        ]
        
        cell.messageLabel.linkTextAttributes = linkAttributes
    
        
        
        if allNotifications[indexPath.row].status == Notification.Status.New.rawValue {
            cell.backgroundColor = UIColor.FindaColours.Purple.fade()
        }
        
        return cell
    }

//    @objc func jobAction(_ sender:UITapGestureRecognizer) {
//        sideMenuController?.setContentViewController(with: "MainTabBar")
//        (sideMenuController?.contentViewController as? UITabBarController)?.selectedIndex = 4   // Jobs
//    }

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

}
