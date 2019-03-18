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
    
    
    @IBOutlet weak var jobCardCollection: UICollectionView!
    
    @IBOutlet weak var noJobsLabel: UILabel!
    
    private let refreshControl = UIRefreshControl()
    
    var jobType: JobsManager.JobTypes = .all
    
    var allJobs: [Job] = []
    var loadingFirst: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.transparentNavigationBar()

        if self.jobType.rawValue == "offered" {
            self.noJobsLabel.text = "Currently you have no requests"
        } else {
            self.noJobsLabel.text = "Currently you have no \(self.jobType.rawValue) jobs"
        }
        
        self.setUpCollectionView()
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadJobs()
    }
    
    private func setUpCollectionView(){
        if #available(iOS 10.0, *) {
            jobCardCollection.refreshControl = refreshControl
        } else {
            jobCardCollection.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
//        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        
        var height: CGFloat = 10.0
        
        if let newLayout = jobCardCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            height = newLayout.itemSize.height - 64
        }

        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 8, height: height)

        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        
        // (note, it's critical to actually set the layout to that!!)
        jobCardCollection.collectionViewLayout = layout
    }
    
    func updateCards() {
        self.loadJobs()
    }
    
    @objc private func refreshData(_ sender: Any) {
        
        self.updateCards()
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
                    let errorView = SCLAlertView(appearance: appearance)
                    errorView.showError(
                        "Sorry",
                        subTitle: "Something went wrong talking to the Finda server. Please try again later.")
                }
            }
        }
        
        alertView.showTitle(
            "Are you sure?",
            subTitle: "This will confirm your acceptance of the Job Offer and the Booking Terms and Conditions sent to you by email. If you want to negotiate the fee, you can do this on the Finda website before accepting.",
            style: .question,
            closeButtonTitle: "Cancel",
            colorStyle: 0x13AFC0,
            colorTextButton: 0xFFFFFF)
    
    }
    
    @objc private func rejectJob(sender: UIButton) {
        
        let appearance = SCLAlertView.SCLAppearance()

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
                    let errorView = SCLAlertView(appearance: appearance)
                    errorView.showError(
                        "Sorry",
                        subTitle: "Something went wrong talking to the Finda server. Please try again later.")
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
                    let errorView = SCLAlertView(appearance: appearance)
                    errorView.showError(
                        "Sorry",
                        subTitle: "Something went wrong talking to the Finda server. Please try again later.")
                }
            }
        }
        alertView.showTitle(
            "Are you sure?",
            subTitle: "",
            style: .warning,
            closeButtonTitle: "Close",
            colorStyle: 0x13AFC0,
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
                    
                    let errorView = SCLAlertView(appearance: appearance)
                    errorView.showError(
                        "Sorry",
                        subTitle: "Something went wrong talking to the Finda server. Please try again later.")
                }
            }
        }
        alertView.showTitle(
            "Are you sure?",
            subTitle: "You will be able to negotiate a different rate if the client offers you this job later.",
            style: .warning,
            closeButtonTitle: "Cancel",
            colorStyle: 0x13AFC0,
            colorTextButton: 0xFFFFFF)
        
    }
    
    
    
    @objc private func downloadCallsheet(sender: UIButton) {
        
        let jobid = String(sender.tag)
        if let url = URL(string: "https://finda.co/download/callsheet/\(jobid)") {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self.parent as? SFSafariViewControllerDelegate
        }
        
    }
    
    @objc private func negotiateJob(sender: UIButton) {
        
        let jobid = sender.tag
        
        var job = self.allJobs[0]
        
        for thisJob in self.allJobs {
            if thisJob.jobid == jobid {
                job = thisJob
            }
        }
        
        let appearance = SCLAlertView.SCLAppearance()
        let alertView = SCLAlertView(appearance: appearance)
        let newRateField = alertView.addTextField("Enter your desired rate")
        
        alertView.addButton("Negotiate") {
            // the value we need is in newRate
            let newRate = Int(newRateField.text!)
//            if (newRate! >= job.offeredRate) {
                SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Blue)
                SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
                SVProgressHUD.show()
                FindaAPISession(target: .negotiateRate(jobId: jobid, newRate: newRate!)) { (response, result) in
                    if response {
                        let noticeView = SCLAlertView()
                        noticeView.showInfo("Negotiation Sent", subTitle: "The Client should respond shortly")
                        self.loadJobs()
                    } else {
                        SVProgressHUD.dismiss()
                        let errorView = SCLAlertView(appearance: appearance)
                        errorView.showError(
                            "Sorry",
                            subTitle: "Something went wrong sending your negotiation. Please try again later.")
                    }
                }
        }

        var subtitle = "The current offered rate is £"
        if job.clientOfferedRate != 0 {
            subtitle = subtitle + "\(job.clientOfferedRate)"
        } else {
            subtitle = subtitle + "\(job.offeredRate)"
        }
        subtitle = subtitle + "/" + job.unitsType + "."
        
        if job.modelDesiredRate != 0 {
            subtitle = subtitle + " You previously asked for £\(job.modelDesiredRate)."
        }
        
        alertView.showTitle(
            "Negotiate Rate",
            subTitle: subtitle,
            style: .question,
            closeButtonTitle: "Cancel",
            colorStyle: 0x13AFC0,
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
                    self.jobCardCollection.reloadData()
//                    self.update()
                    self.loadingFirst = false
                    
                    
                }
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
            } else {
                let appearance = SCLAlertView.SCLAppearance()
                let errorView = SCLAlertView(appearance: appearance)
                errorView.showError(
                    "Sorry",
                    subTitle: "Something went wrong loading your jobs. Please try again later.")
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

extension UILabel {
    func textHeight(withWidth width: CGFloat) -> CGFloat {
        guard let text = text else {
            return 0
        }
        return text.height(withWidth: width, font: font)
    }
    
    func attributedTextHeight(withWidth width: CGFloat) -> CGFloat {
        guard let attributedText = attributedText else {
            return 0
        }
        return attributedText.height(withWidth: width)
    }
}
extension String {
    func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil)
        return actualSize.height
    }
}

extension NSAttributedString {
    func height(withWidth width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)
        return actualSize.height
    }
}

extension JobsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showJobDetailsSegue") {
            let vc = segue.destination as? JobDetailsViewVC
            vc?.job = sender as? Job
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.allJobs.count > 0 ? 1:0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allJobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showJobDetailsSegue", sender: self.allJobs[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "jobcell", for: indexPath) as! JobCardViewCVC
        
        cell.setRounded(radius: 20)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.FindaColours.Grey.cgColor

        cell.jobStatus.text(self.allJobs[indexPath.row].header)
        cell.customerName.text(self.allJobs[indexPath.row].companyName)
        
        cell.jobStatusColour.backgroundColor = UIColor.FindaColours.FindaRed
        cell.jobStatus.textColor = UIColor.FindaColours.Black
        
        let jobStatus = self.allJobs[indexPath.row].header
        
        switch JobStatus(rawValue: jobStatus) {
            case .Requested?:
                
//                cell.layer.borderColor = UIColor.FindaColours.Blue.cgColor
//                cell.jobStatusColour.backgroundColor = UIColor.FindaColours.Blue
                cell.jobStatus.textColor = UIColor.FindaColours.Blue
                
                break
            
            case .Accepted?:
//                cell.layer.borderColor = UIColor.FindaColours.FindaGreen.cgColor
//                cell.jobStatusColour.backgroundColor = UIColor.FindaColours.FindaGreen
                cell.jobStatus.textColor = UIColor.FindaColours.FindaGreen
                break
 
            case .Confirmed?:
//                cell.layer.borderColor = UIColor.FindaColours.FindaGreen.cgColor
//                cell.jobStatusColour.backgroundColor = UIColor.FindaColours.FindaGreen
                cell.jobStatus.textColor = UIColor.FindaColours.FindaGreen
                break
            
            case .ModelCompleted?, .Completed?, .ClientCompleted?:
//                cell.layer.borderColor = UIColor.FindaColours.Yellow.cgColor
//                cell.jobStatusColour.backgroundColor = UIColor.FindaColours.Yellow
                cell.jobStatus.textColor = UIColor.FindaColours.Yellow
                
                cell.jobStatus.text("COMPLETED")
                break
            
            case .Expired?:
//                cell.layer.borderColor = UIColor.FindaColours.LightGreen.cgColor
//                cell.jobStatusColour.backgroundColor = UIColor.FindaColours.LightGreen
                break
            
            case .Finished?:
//                cell.layer.borderColor = UIColor.FindaColours.Black.cgColor
//                cell.jobStatusColour.backgroundColor = UIColor.FindaColours.Black
                break
            
            
            // not used
            case .Optioned?:
                break
            case .Pending?:
                break
            case .Offered?:
                break
            case .Unfinalised?:
                break
            case .none:
//                cell.jobStatusColour.backgroundColor = UIColor.FindaColours.FindaRed
                break
        }
        
        cell.jobTitle.text = self.allJobs[indexPath.row].name
        cell.jobType.text = self.allJobs[indexPath.row].jobtype
        
//        cell.jobDates.text = Date().displayDate(timeInterval: self.allJobs[indexPath.row].startdate, format: "MMM dd, yyyy") + " at " + Date().displayDate(timeInterval: self.allJobs[indexPath.row].starttime, format: "h:mm a")
        
        cell.jobDates.text = Date().displayDate(timeInterval: self.allJobs[indexPath.row].startdate, format: "dd MMM")
        cell.jobTime.text = Date().displayDate(timeInterval: self.allJobs[indexPath.row].starttime, format: "HH:mm")
//        cell.agreedRate.text = "£\(self.allJobs[indexPath.row].agreedRate)/\(self.allJobs[indexPath.row].unitsType.capitalizingFirstLetter())"
    
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
}
