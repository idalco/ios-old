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
    var loadingFirst: Bool = true
    
    
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
        self.loadJobs()
    }
    
    private func update(){
        self.walletView.removeAll()
        self.cardViews.removeAll()
        
        for job in self.allJobs {
            let cardView = JobCardView.nibForClass()
            cardView.clientName = job.companyName.uppercased()
            cardView.duration = JobsManager.length(length: job.timeUnits, unit: job.unitsType).uppercased()
            cardView.header = job.header.uppercased()
            cardView.jobDates = Date().displayDate(timeInterval: job.startdate, format: "MMM dd, yyyy")
            cardView.jobDescription = job.description
            cardView.jobName = job.name.uppercased()
            cardView.jobType = job.jobtype.uppercased()
            cardView.location = job.location.uppercased()
            cardView.offeredNumber = "£\(job.agreedRate)/\(job.unitsType.capitalizingFirstLetter())"
            
            if let jobStatus = JobStatus(rawValue: job.header) {
                switch(jobStatus){
                case .Accepted:
                    cardView.primaryButton.setTitle("CANCEL", for: .normal)
                    cardView.seconaryButton.isHidden = true
                    break
                case .Completed:
                    cardView.primaryButton.isHidden = true
                    cardView.seconaryButton.isHidden = true
                    break
                case .Expired:
                    cardView.primaryButton.isHidden = true
                    cardView.seconaryButton.isHidden = true
                    break
                case .Finished:
                    cardView.primaryButton.setTitle("Waiting for Client to complete", for: .normal)
                    cardView.primaryButton.isEnabled = false
                    cardView.seconaryButton.isHidden = true
                    break
                case .Offered:
                    break
                case .Optioned:
                    cardView.offeredLabel.text = "Offered rate:"
                    cardView.offeredLabel.isHidden = false
                    cardView.offeredNumber = "£\(job.offeredRate)/\(job.unitsType.uppercased())"
                    cardView.offeredNumberButton.isHidden = false
                    cardView.offeredNumberButton.isEnabled = true
                    
                    cardView.primaryButton.setTitle("ACCEPT", for: .normal)
                    cardView.seconaryButton.setTitle("REJECT", for: .normal)
                    
                    break
                case .Unfinalised:
                    cardView.primaryButton.setTitle("COMPLETE", for: .normal)
                    cardView.seconaryButton.isHidden = true
                    break
                    
                }
            }
           
            
            
            
            
            /*
             
             statustext[0] = 'INVALID';
             $statustext[1] = 'OFFERED';
             $statustext[2] = 'ACCEPTED';
             $statustext[3] = 'MODEL_CANCELLED';
             $statustext[4] = 'CLIENT_CANCELLED';
             $statustext[5] = 'MODEL_COMPLETED';
             $statustext[6] = 'CLIENT_COMPLETED';
             $statustext[7] = 'COMPLETED'
 
             */
            
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
    
    
    private func loadJobs(){
        JobsManager.getJobs(jobType: self.jobType) { (response, result) in
            if(response) {
                let jobs = result["userdata"].dictionaryValue
                var jobsArray: [Job] = []
                for job in jobs {
                    jobsArray.append(Job(data: job.value))
                }
                if self.loadingFirst || !self.allJobs.elementsEqual(jobsArray, by: { (job1: Job, job2:Job) -> Bool in
                    job1 == job2
                }){
                    self.allJobs = jobsArray
                    self.update()
                    self.loadingFirst = false
                }
            }
        }
        
    }

    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    @IBAction func menuButton(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    
}
