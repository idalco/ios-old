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
    
    override func viewDidLayoutSubviews() {
        for card in self.cardViews {
            
            switch(card.header) {
            case "PENDING":
                card.layer.borderColor = UIColor.FindaColours.DarkYellow.cgColor
                card.layer.addBorder(edge: .top, color: UIColor.FindaColours.DarkYellow, thickness: 8.0)
                break
                
            case "ACCEPTED":
                card.layer.borderColor = UIColor.FindaColours.Blue.cgColor
                card.layer.addBorder(edge: .top, color: UIColor.FindaColours.Blue, thickness: 8.0)
                break
                
            case "OFFERED":
                card.layer.borderColor = UIColor.FindaColours.DarkYellow.cgColor
                card.layer.addBorder(edge: .top, color: UIColor.FindaColours.DarkYellow, thickness: 8.0)
                break
                
            case "MODEL_COMPLETED":
                card.headerLabel.text = "COMPLETED"
                card.layer.borderColor = UIColor.FindaColours.Purple.cgColor
                card.layer.addBorder(edge: .top, color: UIColor.FindaColours.Purple, thickness: 8.0)
                break
                
            case "OPTIONED":
                card.layer.borderColor = UIColor.FindaColours.DarkYellow.cgColor
                card.layer.addBorder(edge: .top, color: UIColor.FindaColours.DarkYellow, thickness: 8.0)
                break
                
            case "COMPLETED":
                card.layer.borderColor = UIColor.FindaColours.Black.cgColor
                card.layer.addBorder(edge: .top, color: UIColor.FindaColours.Black, thickness: 8.0)
                break
                
            default:
                break
            }
        }
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
            
            cardView.primaryButton.tag = job.jobid
            cardView.secondaryButton.tag = job.jobid
            
            if let jobStatus = JobStatus(rawValue: job.header) {
                switch(jobStatus){
                case .Accepted:
                    cardView.primaryButton.setTitle("CANCEL", for: .normal)
                    cardView.secondaryButton.isHidden = true
                    
                    cardView.primaryButton.addTarget(self, action: #selector(cancelJob(sender:)), for: .touchUpInside)
                    
                    break
                case .Completed:
                    cardView.primaryButton.isHidden = true
                    cardView.secondaryButton.isHidden = true
                    break
                case .Expired:
                    cardView.primaryButton.isHidden = true
                    cardView.secondaryButton.isHidden = true
                    break
                case .Finished:
                    cardView.primaryButton.setTitle("Waiting for Client to complete", for: .normal)
                    cardView.primaryButton.isEnabled = false
                    cardView.secondaryButton.isHidden = true
                    break
                case .Optioned:
                    cardView.offeredLabel.text = "Offered rate:"
                    cardView.offeredLabel.isHidden = false
                    cardView.offeredNumber = "£\(job.offeredRate)/\(job.unitsType.uppercased())"
                    cardView.primaryButton.isHidden = true
                    cardView.secondaryButton.isHidden = false
                    cardView.secondaryButton.setTitle("REJECT", for: .normal)
                    break
                case .Offered:
                    cardView.offeredLabel.text = "Offered rate:"
                    cardView.offeredLabel.isHidden = false
                    cardView.offeredNumber = "£\(job.offeredRate)/\(job.unitsType.uppercased())"
                    cardView.offeredNumberButton.isHidden = false
                    cardView.offeredNumberButton.isEnabled = true
                    
                    cardView.primaryButton.setTitle("ACCEPT", for: .normal)
                    cardView.secondaryButton.setTitle("REJECT", for: .normal)
                    
                    
                    cardView.primaryButton.addTarget(self, action: #selector(acceptJob(sender:)), for: .touchUpInside)
                    cardView.primaryButton.addTarget(self, action: #selector(rejectJob(sender:)), for: .touchUpInside)

                    break
                case .Unfinalised:
                    cardView.primaryButton.setTitle("COMPLETE", for: .normal)
                    cardView.secondaryButton.isHidden = true
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

    @objc private func acceptJob(sender: UIButton){
//        FindaAPISession(target: .acceptJob(jobId: sender.tag)) { (response, result) in
//            if response {
//                self.loadJobs()
//            }
//        }
    }
    
    @objc private func rejectJob(sender: UIButton){
//        FindaAPISession(target: .rejectJob(jobId: sender.tag)) { (response, result) in
//            if response {
//                self.loadJobs()
//            }
//        }
    }
    
    @objc private func cancelJob(sender: UIButton){
//        FindaAPISession(target: .cancelJob(jobId: sender.tag)) { (response, result) in
//            if response {
//                self.loadJobs()
//            }
//        }
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
