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

            for item in card.layer.sublayers! {
                if item.name == "border" {
                    item.frame = CGRect(x: 0, y: 0, width: card.layer.frame.width, height: 8)
                }
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
            cardView.jobDates = Date().displayDate(timeInterval: job.startdate, format: "MMM dd, yyyy") + " at " + Date().displayDate(timeInterval: job.starttime, format: "h:mm a")
            cardView.jobDescription = job.description
            cardView.jobName = job.name.uppercased()
            cardView.jobType = job.jobtype.uppercased()
            cardView.location = job.location.uppercased()
            cardView.offeredNumber = "£\(job.agreedRate)/\(job.unitsType.capitalizingFirstLetter())"
            
            if (job.contact_number != "") {
                cardView.contactNumberLabel.isHidden = false
                cardView.contactNumberLabelIcon.isHidden = false
                cardView.contactNumber = job.contact_number
            } else {
                cardView.contactNumberLabel.isHidden = true
                cardView.contactNumberLabelIcon.isHidden = true
            }
      
            var jobDescriptionLabelframe = cardView.jobDescriptionLabel.frame
            if (job.advanced != "") {
                cardView.advancedInfo = job.advanced
                jobDescriptionLabelframe.origin.y = 272
                cardView.jobDescriptionLabel.frame = jobDescriptionLabelframe
                cardView.advancedInfoLabel.isHidden = false
            } else {
                cardView.advancedInfoLabel.isHidden = true
                jobDescriptionLabelframe.origin.y = 192
                cardView.jobDescriptionLabel.frame = jobDescriptionLabelframe
            }
            
            cardView.primaryButton.tag = job.jobid
            cardView.secondaryButton.tag = job.jobid
            
            if let jobStatus = JobStatus(rawValue: job.header) {
                
                switch(jobStatus) {
                    
                case .Pending:
                    cardView.layer.borderColor = UIColor.FindaColours.DarkYellow.cgColor
                    cardView.layer.addBorder(edge: .top, color: UIColor.FindaColours.DarkYellow, thickness: 8.0)

                    break;
                    
                    case .Accepted:
                        cardView.secondaryButton.setTitle("CANCEL", for: .normal)
                        cardView.primaryButton.isHidden = true
                        
                        cardView.secondaryButton.addTarget(self, action: #selector(cancelJob(sender:)), for: .touchUpInside)
                        cardView.offeredLabel.isHidden = false
                        cardView.offeredNumberButton.isHidden = false
                        cardView.offeredLabel.text = "Agreed rate:"
                        cardView.offeredNumber = "£\(job.agreedRate)/\(job.unitsType.uppercased())"
                        break
                    case .ModelCompleted, .Completed:
                        cardView.primaryButton.isHidden = true
                        cardView.secondaryButton.isHidden = true
                        cardView.offeredLabel.text = "Offered rate:"
                        cardView.offeredLabel.isHidden = false
                        cardView.offeredNumber = "£\(job.offeredRate)/\(job.unitsType.uppercased())"
                        break
                    case .Expired:
                        cardView.primaryButton.isHidden = true
                        cardView.secondaryButton.isHidden = true
                        cardView.contactNumberLabel.isHidden = true
                        cardView.contactNumberLabelIcon.isHidden = true
                        break
                    case .Finished:
                        cardView.primaryButton.setTitle("Waiting for Client to complete", for: .normal)
                        cardView.primaryButton.isEnabled = false
                        cardView.secondaryButton.isHidden = true
                        cardView.contactNumberLabel.isHidden = true
                        cardView.contactNumberLabelIcon.isHidden = true
                        break
                    case .Optioned:
                        cardView.offeredLabel.text = "Offered rate:"
                        cardView.offeredLabel.isHidden = false
                        cardView.offeredNumber = "£\(job.offeredRate)/\(job.unitsType.uppercased())"
                        cardView.primaryButton.isHidden = true
                        cardView.secondaryButton.isHidden = false
                        cardView.secondaryButton.setTitle("REJECT", for: .normal)
                        
                        cardView.secondaryButton.addTarget(self, action: #selector(rejectOption(sender:)), for: .touchUpInside)
                        cardView.contactNumberLabel.isHidden = true
                        cardView.contactNumberLabelIcon.isHidden = true
                        
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
                        cardView.secondaryButton.addTarget(self, action: #selector(rejectJob(sender:)), for: .touchUpInside)

                        cardView.contactNumberLabel.isHidden = true
                        cardView.contactNumberLabelIcon.isHidden = true
                        
                        break
                    case .Unfinalised:
                        cardView.primaryButton.setTitle("COMPLETE", for: .normal)
                        cardView.secondaryButton.isHidden = true
                        cardView.contactNumberLabel.isHidden = true
                        break
                    
                }
            }
            
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
        FindaAPISession(target: .acceptJob(jobId: sender.tag)) { (response, result) in
            if response {
                self.loadJobs()
            }
        }
    }
    
    @objc private func rejectJob(sender: UIButton){
        FindaAPISession(target: .rejectJob(jobId: sender.tag)) { (response, result) in
            if response {
                self.loadJobs()
            }
        }
    }
    
    @objc private func cancelJob(sender: UIButton){
        FindaAPISession(target: .cancelJob(jobId: sender.tag)) { (response, result) in
            if response {
                self.loadJobs()
            }
        }
    }

    @objc private func rejectOption(sender: UIButton){
        FindaAPISession(target: .rejectOption(jobId: sender.tag)) { (response, result) in
            if response {
                self.loadJobs()
            }
        }
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
