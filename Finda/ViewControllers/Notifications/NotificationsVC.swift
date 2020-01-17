//
//  NotificationsVC.swift
//  Finda
//
//  Created by Peter Lloyd on 06/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var allNotifications: [Notification] = []
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.navigationController?.navigationBar.transparentNavigationBar()
        self.messageView.backgroundColor = UIColor.FindaColours.LightGrey
        self.messageLabel.textColor = UIColor.FindaColours.Blue
        self.navigationController?.navigationBar.topItem?.title = "UPDATES"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadNotifications()
    }
    
    @IBAction func showMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
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
    
    @objc private func loadNotifications() {
        SVProgressHUD.setBackgroundColor(UIColor.FindaColours.LightGrey)
        SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
        SVProgressHUD.show()
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
                    self.messageView.isHidden = true
                    self.messageViewHeight.constant = 0
                    self.view.layoutIfNeeded()
                } else {
                    self.tableView.isHidden = true
                    self.messageLabel.text = "Currently you have no updates"
                    self.messageViewHeight.constant = 53
                    self.view.layoutIfNeeded()
                }
                self.tableView.reloadData()
            } else {
                self.tableView.isHidden = true
                self.messageLabel.text = "Currently you have no updates"
                self.messageViewHeight.constant = 53
                self.view.layoutIfNeeded()
            }
            SVProgressHUD.dismiss()
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allNotifications.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(jobAction(recognizer:)))
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationCell
        
        tableView.addGestureRecognizer(gesture)
        
        if allNotifications[indexPath.row].type == Notification.MessageType.CHATIMAGE.rawValue {
            cell.messageImage.isHidden = false
            cell.messageImageWidth.constant = 20
            
            if let imageUrl = URL(string: allNotifications[indexPath.row].subject) {
                cell.messageImage.af_setImage(withChatImageURL: imageUrl, imageTransition: .crossDissolve(0.2))
            }
            
            cell.layoutIfNeeded()
            
        }
        
        var sendername = allNotifications[indexPath.row].firstname + " " + allNotifications[indexPath.row].lastname
        
        if allNotifications[indexPath.row].usertype == 2 {
            if allNotifications[indexPath.row].companyname != "" {
                sendername += ", " + allNotifications[indexPath.row].companyname
            }
        }
        cell.senderNameLabel.text = sendername

        cell.dateLabel.text = Date().displayDate(timeInterval: allNotifications[indexPath.row].timestamp, format:  "MMM dd, yyyy")
        cell.messageLabel.attributedText = allNotifications[indexPath.row].message.htmlAttributed(family: "Montserrat-Light")
        
        // set avatar here
        cell.messageAvatar.setRounded(radius: 2, colour: UIColor.FindaColours.LightGrey.cgColor)
        
        if allNotifications[indexPath.row].avatar != "/default_profile.png" {
            if let imageUrl = URL(string: allNotifications[indexPath.row].avatar){
                cell.messageAvatar.af_setImage(withAvatarURL: imageUrl, imageTransition: .crossDissolve(0.2))
            }
        } else if allNotifications[indexPath.row].avatar != "" {
            if let imageUrl = URL(string: allNotifications[indexPath.row].avatar) {
                cell.messageAvatar.af_setImage(withPortfolioURL: imageUrl, imageTransition: .crossDissolve(0.2))
            }
        } else {
            if let imageUrl = URL(string: allNotifications[indexPath.row].avatar) {
                cell.messageAvatar.af_setImage(withAvatarURL: imageUrl, imageTransition: .crossDissolve(0.2))
            }
        }
        
        let linkAttributes: [NSAttributedString.Key : Any] = [
            
            
            
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.FindaColours.Black,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.underlineStyle.rawValue): [],
            NSAttributedString.Key(rawValue: NSAttributedString.Key.underlineColor.rawValue): UIColor.FindaColours.Blue,
        ]
        
        cell.messageLabel.linkTextAttributes = linkAttributes
    
        if allNotifications[indexPath.row].status == Notification.Status.New.rawValue {
//            cell.backgroundColor = UIColor.FindaColours.Purple.fade()
            cell.unreadBar.backgroundColor = UIColor.FindaColours.Burgundy
        } else {
            cell.unreadBar.backgroundColor = UIColor.FindaColours.White
        }
    
        
        cell.tag = allNotifications[indexPath.row].jobid
    
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let notificationId = allNotifications[indexPath.row].id
            NotificationManager.deleteNotifications(id: notificationId)
            allNotifications.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ChatVC {
            let vc = segue.destination as? ChatVC
            if let message = sender as? Notification {
                vc?.senderId = message.sender
            }
        }
    }
    
    @objc func jobAction(recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizer.State.ended {
            
            let tapLocation = recognizer.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                if (self.tableView.cellForRow(at: tapIndexPath) as? NotificationCell) != nil {
                    //do what you want to cell here

                    if self.allNotifications[tapIndexPath.row].type == Notification.MessageType.COMPOSED.rawValue
                    || self.allNotifications[tapIndexPath.row].type == Notification.MessageType.CHATIMAGE.rawValue
                    || self.allNotifications[tapIndexPath.row].type == Notification.MessageType.CHATPDF.rawValue {
                        // composed notification
                        let message = self.allNotifications[tapIndexPath.row]
                        performSegue(withIdentifier: "showChat", sender: message)
                        
                    } else {
                        // potential job notification
                        let cell = self.tableView.cellForRow(at: tapIndexPath)
                        
                        if let msgid = cell?.tag {
                            let preferences = UserDefaults.standard
                            preferences.set("tappedNotification", forKey: "sourceAction")
                            preferences.set(msgid, forKey: "showJobIdCard")
                            preferences.synchronize()
                            
                            // now we have to move VC
                            let smc = sideMenuController
                            smc?.setContentViewController(with: "MainTabBar")
                            (smc?.contentViewController as? UITabBarController)?.selectedIndex = 1
                        }
                    }
                    
                }
            }
        }
    }

}
