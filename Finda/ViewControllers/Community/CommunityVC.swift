//
//  CommunityVC.swift
//  Finda
//
//  Created by Tom Gordon on 18/04/2020.
//  Copyright © 2020 Finda Ltd. All rights reserved.
//

import Foundation
import SVProgressHUD
import SCLAlertView
import DCKit
import SideMenuSwift

class CommunityVC: UIViewController {
    
    @IBOutlet weak var communityPostsTable: UITableView!
    
    var communityPosts: [CommunityPost] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "iDAL Community"
        
        self.setUpTableView()
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    private func setUpTableView() {

        updatePosts()
        
    }
    
    func updatePosts() {
        self.loadCommunityPosts()
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.loadCommunityPosts()
    }
    
    @objc public func loadCommunityPosts() {
        SVProgressHUD.setBackgroundColor(UIColor.FindaColours.LightGrey)
        SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
        SVProgressHUD.show()
        FindaAPISession(target: .getCommunityPosts) { (response, result) in
            SVProgressHUD.dismiss()
            if (response) {
                let posts = result["userdata"].arrayValue

                for post in posts {
                    
                    let postObject: CommunityPost = CommunityPost(data: post)
                    self.communityPosts.append(postObject)
                }
                self.communityPostsTable.reloadData()
            }
        }
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
}

extension CommunityVC: UITableViewDelegate, UITableViewDataSource {
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.communityPosts.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.communityPosts.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = communityPostsTable.dequeueReusableCell(withIdentifier: "communityItemCell", for: indexPath) as! CommunityTableViewCell
        
        let post = communityPosts[indexPath.row]
        
        cell.communityItemTitle.text = post.subject
        cell.communityItemContent.text = post.message
        
        let postedDate = Date().displayDate(timeInterval: post.timestamp, format:  "MMM dd, yyyy")
        cell.communityItemDate.text = "Posted by iDAL Team on " + postedDate
        
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// not called
    }

    

}

