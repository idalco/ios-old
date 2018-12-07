//
//  JobsVC.swift
//  Finda
//
//  Created by Peter Lloyd on 10/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import SCLAlertView
import SafariServices

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

        if self.jobType.rawValue == "offered" {
            self.noJobsLabel.text = "Currently you have no requests"
        } else {
            self.noJobsLabel.text = "Currently you have no \(self.jobType.rawValue) jobs"
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadJobs()
    }
    
    override func viewDidLayoutSubviews() {
        for card in self.cardViews {
            
            // by default, hide contact number
            card.contactNumberLabelIcon.isHidden = true
            card.contactNumberLabel.isHidden = true
            
            switch(card.header) {
            case "PENDING":
                card.layer.borderColor = UIColor.FindaColours.DarkYellow.cgColor
                card.layer.addBorder(edge: .top, color: UIColor.FindaColours.DarkYellow, thickness: 8.0)
                break
                
            case "ACCEPTED":
                
                card.layer.borderColor = UIColor.FindaColours.Blue.cgColor
                card.layer.addBorder(edge: .top, color: UIColor.FindaColours.Blue, thickness: 8.0)
                card.contactNumberLabelIcon.isHidden = false
                card.contactNumberLabel.isHidden = false
                break
                
            case "OFFERED", "REQUESTED":
                card.headerLabel.text = "REQUESTED"
                card.layer.borderColor = UIColor.FindaColours.DarkYellow.cgColor
                card.layer.addBorder(edge: .top, color: UIColor.FindaColours.DarkYellow, thickness: 8.0)
                break
                
            case "MODEL_COMPLETED":
                card.headerLabel.text = "COMPLETED"
                card.layer.borderColor = UIColor.FindaColours.Purple.cgColor
                card.layer.addBorder(edge: .top, color: UIColor.FindaColours.Purple, thickness: 8.0)
                break
                
            case "OPTIONED", "JOB OFFER":
                card.layer.borderColor = UIColor.FindaColours.DarkYellow.cgColor
                card.layer.addBorder(edge: .top, color: UIColor.FindaColours.DarkYellow, thickness: 8.0)
                break
                
            case "COMPLETED":
                card.layer.borderColor = UIColor.FindaColours.Black.cgColor
                card.layer.addBorder(edge: .top, color: UIColor.FindaColours.Black, thickness: 8.0)
                break

            case "EXPIRED":
                card.layer.borderColor = UIColor.FindaColours.Black.cgColor
                card.layer.addBorder(edge: .top, color: UIColor.FindaColours.Black, thickness: 8.0)
                break

            case "CONFIRMED":
                card.layer.borderColor = UIColor.FindaColours.FindaGreen.cgColor
                card.layer.addBorder(edge: .top, color: UIColor.FindaColours.FindaGreen, thickness: 8.0)
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
                    
                    // 14 is accepted, 2 if confirmed, so we need to override here,
                    // or refactor
                    if job.status == 2 {
                        cardView.header = "CONFIRMED"
                    }
                    
                    break
                case .ModelCompleted, .Completed:
                    cardView.primaryButton.isHidden = true
                    cardView.secondaryButton.isHidden = true
                    cardView.offeredLabel.text = "Offered rate:"
                    cardView.offeredLabel.isHidden = false
                    cardView.offeredNumberButton.isHidden = false
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
                    cardView.offeredNumberButton.isHidden = false
                    cardView.offeredNumber = "£\(job.offeredRate)/\(job.unitsType.uppercased())"
                    
                    cardView.primaryButton.isHidden = false
                    cardView.primaryButton.setTitle("ACCEPT", for: .normal)
                    cardView.primaryButton.addTarget(self, action: #selector(acceptJob(sender:)), for: .touchUpInside)
                    cardView.secondaryButton.isHidden = false
                    cardView.secondaryButton.setTitle("REJECT", for: .normal)
                    cardView.secondaryButton.addTarget(self, action: #selector(rejectOption(sender:)), for: .touchUpInside)
                    cardView.contactNumberLabel.isHidden = true
                    cardView.contactNumberLabelIcon.isHidden = true
                    
                    // override
                    cardView.header = "JOB OFFER"
                    break
                
                case .Requested:
                    cardView.offeredLabel.text = "Offered rate:"
                    cardView.offeredLabel.isHidden = false
                    cardView.offeredNumberButton.isHidden = false
                    cardView.offeredNumber = "£\(job.offeredRate)/\(job.unitsType.uppercased())"
                    
                    cardView.primaryButton.isHidden = false
                    cardView.primaryButton.setTitle("ACCEPT", for: .normal)
                    cardView.primaryButton.addTarget(self, action: #selector(acceptJob(sender:)), for: .touchUpInside)
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
                    
                case .Confirmed:
                    cardView.secondaryButton.setTitle("CANCEL", for: .normal)
                    cardView.primaryButton.isHidden = true
                    
                    cardView.secondaryButton.addTarget(self, action: #selector(cancelJob(sender:)), for: .touchUpInside)
                    cardView.offeredLabel.isHidden = false
                    cardView.offeredNumberButton.isHidden = false
                    cardView.offeredLabel.text = "Agreed rate:"
                    cardView.offeredNumber = "£\(job.agreedRate)/\(job.unitsType.uppercased())"
                    
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

    @objc private func acceptJob(sender: UIButton) {
        
        let appearance = SCLAlertView.SCLAppearance()
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("View Terms") {
            if let destination = NSURL(string: domainURL + "/bookingterms") {
                
                let safari = SFSafariViewController(url: destination as URL, entersReaderIfAvailable: true)
                self.present(safari, animated: true)
            }
        }
        alertView.addButton("Accept Offer") {
            SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Blue)
            SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
            SVProgressHUD.show()
            FindaAPISession(target: .acceptJob(jobId: sender.tag)) { (response, result) in
                if response {
                    self.loadJobs()
                } else {
                    SVProgressHUD.dismiss()
                }
            }
        }
        
        alertView.showTitle(
            "Are you sure?",
            subTitle: "This will confirm your acceptance of the Job Offer and the Booking Terms and Conditions sent to you by email. If you want to negotiate the fee, you can do this on the Finda website before accepting.",
            style: .question,
            closeButtonTitle: "Cancel",
            colorStyle: 0x59C5CF,
            colorTextButton: 0xFFFFFF)
    
    }
    
    @objc private func rejectJob(sender: UIButton) {

        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Reject offer", style: UIAlertAction.Style.default, handler: { action in
            SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Blue)
            SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
            SVProgressHUD.show()
            FindaAPISession(target: .rejectJob(jobId: sender.tag)) { (response, result) in
                if response {
                    self.loadJobs()
                } else {
                    SVProgressHUD.dismiss()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    @objc private func cancelJob(sender: UIButton) {
        
        
        let appearance = SCLAlertView.SCLAppearance()
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("Cancel Job") {
            SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Blue)
            SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
            SVProgressHUD.show()
            FindaAPISession(target: .cancelJob(jobId: sender.tag)) { (response, result) in
                if response {
                    self.loadJobs()
                } else {
                    SVProgressHUD.dismiss()
                }
            }
        }
        alertView.showTitle(
            "Are you sure?",
            subTitle: "",
            style: .warning,
            closeButtonTitle: "Close",
            colorStyle: 0x59C5CF,
            colorTextButton: 0xFFFFFF)
        
    }

    @objc private func rejectOption(sender: UIButton) {
        
        let appearance = SCLAlertView.SCLAppearance()
        let alertView = SCLAlertView(appearance: appearance)

        alertView.addButton("Decline Offer") {
            SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Blue)
            SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
            SVProgressHUD.show()
            FindaAPISession(target: .rejectOption(jobId: sender.tag)) { (response, result) in
                if response {
                    self.loadJobs()
                } else {
                    SVProgressHUD.dismiss()
                }
            }
        }
        alertView.showTitle(
            "Are you sure?",
            subTitle: "You will be able to negotiate a different rate if the client offers you this job later.",
            style: .warning,
            closeButtonTitle: "Cancel",
            colorStyle: 0x59C5CF,
            colorTextButton: 0xFFFFFF)
        
    }
    
    private func loadJobs() {
        
        JobsManager.getJobs(jobType: self.jobType) { (response, result) in
            if (response) {
                let jobs = result["userdata"].dictionaryValue
                var jobsArray: [Job] = []
                for job in jobs {
                    jobsArray.append(Job(data: job.value))
                }
                if self.loadingFirst || !self.allJobs.elementsEqual(jobsArray, by: { (job1: Job, job2:Job) -> Bool in
                    job1 == job2
                }) {
                    self.allJobs = jobsArray
                    self.update()
                    self.loadingFirst = false
                }
                SVProgressHUD.dismiss()
                
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
