//
//  ChatVC.swift
//  Finda
//
//  Created by cro on 12/09/2019.
//  Copyright © 2019 Finda Ltd. All rights reserved.
//

import Foundation

import SVProgressHUD
import DCKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var tableChatMessagesCollection: UITableView!
    @IBOutlet weak var backButton: UIImageView!
    
    @IBOutlet weak var chatTitle: UILabel!
    @IBOutlet weak var newMessageText: UITextView!
    @IBOutlet weak var sendMessageButton: DCBorderedButton!
    
    var senderId: Int = 0
    
    var senderName: String = ""
    var myAvatar: String = ""
    
    var notifications: [Notification] = []
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(ChatVC.backButtonTapped))
        backButton.addGestureRecognizer(tapRec)
        backButton.isUserInteractionEnabled = true
        
        self.navigationController?.navigationBar.transparentNavigationBar()
        self.chatTitle.text = "Chat with ..."
        
        sendMessageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        newMessageText.delegate = self
        newMessageText.text = "Your message";
        newMessageText.textColor = UIColor.lightGray;
        
        
        // need to get my avatar
        let modelManager = ModelManager()
        if modelManager.avatar() != "/default_profile.png" {
            self.myAvatar = modelManager.avatar()
        }
        
        
        self.setUpCollectionView()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Your message"
            textView.textColor = UIColor.lightGray
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadChatMessages()
    }
    
    private func setUpCollectionView() {
        
        if #available(iOS 10.0, *) {
            tableChatMessagesCollection.refreshControl = refreshControl
        } else {
            tableChatMessagesCollection.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
    }
    
    
    @objc private func refreshData(_ sender: Any) {
        self.loadChatMessages()
    }
    
    @objc public func loadChatMessages() {
        
        SVProgressHUD.setBackgroundColor(UIColor.FindaColours.LightGrey)
        SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
        SVProgressHUD.show()

        NotificationManager.getChatMessages(sender: senderId) { (response, result) in
            self.tableChatMessagesCollection.refreshControl?.endRefreshing()
            self.notifications.removeAll()
            
            if (response) {
                let notifications = result["userdata"].arrayValue
                
                for notification in notifications {
                    let notificationObject: Notification = Notification(data: notification)
                    self.notifications.append(notificationObject)
                    
                    // we can use this
                    if self.senderName == "" {
                        if notificationObject.sender == self.senderId {
                            self.senderName = notificationObject.firstname
                            self.chatTitle.text = "Chat with " + self.senderName
                        }
                    }
                    
                }
                
                self.notifications.sort {
                    $1.timestamp > $0.timestamp
                }

                self.tableChatMessagesCollection.reloadData()
                self.scrollToLast(animated: false)
            }
            SVProgressHUD.dismiss()
            
        }
        

        
    }
    
    @objc private func backButtonTapped(sender: UIImageView) {
        self.dismiss(animated: true)
    }
    
    @objc private func sendMessage(sender: UIButton) {
        let message: String = newMessageText.text!

        newMessageText.text = ""
        
        newMessageText.resignFirstResponder()

        // this is for testing
        let newNotification: Notification = Notification(message: message, recipient: senderId)
        newNotification.avatar = self.myAvatar
        newNotification.timestamp = Int(Date().timeIntervalSince1970)
        
        self.notifications.append(newNotification)
        self.tableChatMessagesCollection.reloadData()
        self.scrollToLast(animated: true)
        // end testing bit
        
        
        // send message
//        print ("\(message)")
        NotificationManager.sendChatMessage(recipient:senderId, message: message) { (response, result) in
            
        }
        
        // then reload? not needed as we're lazy about this
//        self.loadChatMessages()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.notifications.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablechatcell", for: indexPath) as! TableChatVCCell
        
        cell.messageText.text(self.notifications[indexPath.row].message)
        cell.dateStamp.text = Date().displayDate(timeInterval: self.notifications[indexPath.row].timestamp, format: "dd MMM HH:mm")
        
        // since we're reusing cells, show anything that may be hidden
        cell.recipientChatArrow.isHidden = false
        cell.recipientAvatarimage.isHidden = false
        cell.senderChatArrow.isHidden = false
        cell.senderAvatarImage.isHidden = false
        
        if self.notifications[indexPath.row].sender != self.senderId {
            // this is the other person
            cell.recipientChatArrow.isHidden = true
            cell.recipientAvatarimage.isHidden = true
            if let imageUrl = URL(string: self.notifications[indexPath.row].avatar) {
                cell.senderAvatarImage.af_setImage(withAvatarURL: imageUrl, imageTransition: .crossDissolve(0.2))
            }
            if self.myAvatar == "" {
                self.myAvatar = self.notifications[indexPath.row].avatar
            }
        } else {
            // this is us
            cell.senderChatArrow.isHidden = true
            cell.senderAvatarImage.isHidden = true
            if let imageUrl = URL(string: self.notifications[indexPath.row].avatar) {
                cell.recipientAvatarimage.af_setImage(withAvatarURL: imageUrl, imageTransition: .crossDissolve(0.2))
            }
        }
        cell.tag = notifications[indexPath.row].id
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func scrollToLast(animated: Bool = true, delay: Double = 0.0) {
        let numberOfRows = tableChatMessagesCollection.numberOfRows(inSection: tableChatMessagesCollection.numberOfSections - 1) - 1
        guard numberOfRows > 0 else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
            
            let indexPath = IndexPath(
                row: numberOfRows,
                section: self.tableChatMessagesCollection.numberOfSections - 1)
            self.tableChatMessagesCollection.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }


}
