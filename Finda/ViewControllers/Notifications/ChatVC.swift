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
import YPImagePicker

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    // PullUpToRefreshTableviewDelegate
    @IBOutlet weak var tableChatMessagesCollection: UITableView!
    @IBOutlet weak var backButton: UIImageView!
    
    @IBOutlet weak var chatTitle: UILabel!
    @IBOutlet weak var newMessageText: UITextView!
    @IBOutlet weak var sendMessageButton: DCBorderedButton!
    @IBOutlet weak var attachmentButton: UILabel!
    
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
        
        let attachImage = UITapGestureRecognizer(target: self, action: #selector(ChatVC.attachImage))
        attachmentButton.addGestureRecognizer(attachImage)
        attachmentButton.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.transparentNavigationBar()
        self.chatTitle.text = "Message ..."
        
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
        
        
        tableChatMessagesCollection.delegate = self
        
    }
    
    func tableviewDidPullUp() {
        self.loadChatMessages()
    }
    
    func tableviewDidScroll() {
        
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
    
    // MARK: messaging loading & display
    
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
                            if notificationObject.usertype == 2 && notificationObject.companyname != "" {
                                self.chatTitle.text = self.senderName + ", " + notificationObject.companyname
                            } else {
                                self.chatTitle.text = self.senderName
                            }
                            
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
    
    // MARK: send message
    
    @objc private func sendMessage(sender: UIButton) {
        let message: String = newMessageText.text!

        newMessageText.text = ""
        
        newMessageText.resignFirstResponder()

        if message != "" && message != "Your message" {
            self.sendMessageContent(message: message)
        }
    }
    
    func sendMessageContent(message: String, subject: String = "", type: Int = 14) {  // type 14 = MESSAGE_TYPE_COMPOSED
        let newNotification: Notification = Notification(message: message, recipient: senderId)

        newNotification.avatar = self.myAvatar
        newNotification.timestamp = Int(Date().timeIntervalSince1970)
        newNotification.type = type
        newNotification.subject = subject
        
        self.notifications.append(newNotification)
        self.tableChatMessagesCollection.reloadData()
        self.scrollToLast(animated: true)
        
        NotificationManager.sendChatMessage(recipient:senderId, message: newNotification.message, subject: newNotification.subject, type: type) { (response, result) in
            
        }
    }

    // MARK: attach & send image
    
    @objc func attachImage(_ sender: UILabel) {
        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.startOnScreen = .library
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                SVProgressHUD.setBackgroundColor(UIColor.FindaColours.LightGrey)
                SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
                SVProgressHUD.show()
                FindaAPISession(target: .uploadChatImage(image: photo.image), completion: { (response, result) in
                    SVProgressHUD.dismiss()
                    if (response) {
                        let filename = result["filename"]
                        self.sendMessageContent(message: "", subject: filename.stringValue, type: 16)    // type 16 = MESSAGE_TYPE_COMPOSED_IMAGE
                    }
                })
            }
            picker.dismiss(animated: true, completion: nil)
            
        }
        present(picker, animated: true, completion: nil)
    }
    
    
    // MARK: tableview functions
    
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
        
        // message types 16 & 17 have images or PDFs
        if self.notifications[indexPath.row].type == Notification.MessageType.CHATIMAGE.rawValue {
            cell.imageHolder.isHidden = false
            cell.imageHolderHeight.constant = 80
            
            if let imageUrl = URL(string: self.notifications[indexPath.row].subject) {
                cell.imageHolder.af_setImage(withChatImageURL: imageUrl, imageTransition: .crossDissolve(0.2))
            }
            
            let pictureTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatVC.imageTapped(_:)))
            cell.imageHolder.addGestureRecognizer(pictureTap)
            cell.imageHolder.isUserInteractionEnabled = true
            
            cell.layoutIfNeeded()
            
        } else if self.notifications[indexPath.row].type == Notification.MessageType.CHATPDF.rawValue {
            // @todo
        } else {
            cell.imageHolder.isHidden = true
            cell.imageHolderHeight.constant = 4
            cell.layoutIfNeeded()
        }
        
        if self.notifications[indexPath.row].message != "" {
            cell.messageText.text(self.notifications[indexPath.row].message)
        } else {
            // we need to set this item to hidden/zero height
            cell.messageText.isHidden = true
        }
        
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
    
    // this allows us to delete chat messages
    // if we own them
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.notifications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let flag = UITableViewRowAction(style: .normal, title: "Report") { action, index in
            self.FlagFunc(indexPath: indexPath)
        }
        flag.backgroundColor = .red
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.DeleteFunc(indexPath: indexPath)
        }
        delete.backgroundColor = .red
        
        if self.notifications[indexPath.row].sender == self.senderId {
            return [flag]
        } else {
            return [delete]
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func FlagFunc(indexPath: IndexPath) {
        NotificationManager.flagNotifications(id: self.notifications[indexPath.row].id)
        self.notifications.remove(at: indexPath.row)
        self.tableChatMessagesCollection.deleteRows(at: [indexPath], with: .fade)
    }
    func DeleteFunc(indexPath: IndexPath) {
        NotificationManager.deleteNotifications(id: self.notifications[indexPath.row].id)
        self.notifications.remove(at: indexPath.row)
        self.tableChatMessagesCollection.deleteRows(at: [indexPath], with: .fade)
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
    
    // MARK: view image functions
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }

}
