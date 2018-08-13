//
//  JobsVC.swift
//  Finda
//
//  Created by Peter Lloyd on 10/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit

class JobsVC: UIViewController {
    

    @IBOutlet weak var walletView: WalletView!
    @IBOutlet weak var noJobsLabel: UILabel!
    
    var jobType: JobsManager.JobTypes = .all
    
    var cardViews = [JobCardView]()
    var allJobs: [Job] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        walletView.walletHeader = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        self.noJobsLabel.text = "Currently you have no \(self.jobType.rawValue) jobs"
        
//        walletView.didUpdatePresentedCardViewBlock = { [weak self] (_) in
//        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        self.updateNotificationCount()
        self.loadJobs()
    }
    
    private func update(){
        self.walletView.removeAll()
        self.cardViews.removeAll()
        
        for job in self.allJobs {
            let cardView = JobCardView.nibForClass()
            cardView.clientName = job.companyName.uppercased()
            cardView.duration = JobsManager.length(length: job.timeUnits, unit: job.unitsType).uppercased()
            cardView.header = "New Job".uppercased()
            cardView.jobDates = Date().displayDate(timeInterval: job.startdate, format: "MMM dd, yyyy")
            cardView.jobDescription = job.description
            cardView.jobName = job.name.uppercased()
            cardView.jobType = job.jobtype.uppercased()
            cardView.location = job.location.uppercased()
            
            self.cardViews.append(cardView)
      
        }
        if self.allJobs.count > 0 {
            self.walletView.isHidden = false
            self.noJobsLabel.isHidden = true
        } else {
            self.walletView.isHidden = true
            self.noJobsLabel.isHidden = false
        }
        self.walletView.reload(cardViews: self.cardViews)
        
    }
    
    
    private func updateNotificationCount(){
        NotificationManager.countNotifications(notificationType: .new) { (response, result) in
            if response {
                self.tabBarController?.tabBar.items?[1].badgeValue = result["userdata"].string
            }
        }
    }
    
    private func loadJobs(){
        JobsManager.getJobs(jobType: self.jobType) { (response, result) in
            self.allJobs.removeAll()
            if(response) {
                let jobs = result["userdata"].dictionaryValue
                for job in jobs {
                    self.allJobs.append(Job(data: job.value))
                }
            }
            self.update()
        }
        
    }

    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    @IBAction func menuButton(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    
}
