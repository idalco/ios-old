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
import DCKit

class JobsVC: UIViewController {
    
    
    @IBOutlet weak var jobCardCollection: UICollectionView!
    
    @IBOutlet weak var noJobsLabel: UILabel!
    
    private let refreshControl = UIRefreshControl()
    
    var jobType: JobsManager.JobTypes = .all
    
    var allJobs: [Job] = []
    var upcomingJobs: [Job] = []
    var offeredJobs: [Job] = []
    var historyJobs: [Job] = []
    var thisTabJobs: [Job] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Jobs"
        
        if self.jobType.rawValue == "offered" {
            self.noJobsLabel.text = "Currently you have no upcoming jobs"
        } else {
            if self.jobType.rawValue == "Accepted" {
                self.noJobsLabel.text = "Sorry, there are no Upcoming jobs to show"
            } else {
                self.noJobsLabel.text = "Sorry, there are no \(self.jobType.rawValue) jobs to show"
            }
            
        }
        
        self.setUpCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadJobs), name: NSNotification.Name(rawValue: "loadJobs"), object: nil)
        
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    private func setUpCollectionView() {
        self.noJobsLabel.isHidden = true

        if #available(iOS 10.0, *) {
            jobCardCollection.refreshControl = refreshControl
        } else {
            jobCardCollection.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
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
        self.showSpinner(onView: self.jobCardCollection)
        self.loadJobs()
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.loadJobs()
    }
    
    @objc public func loadJobs() {
        
        
        JobsManager.getJobs(jobType: .all) { (response, result) in
            if (response) {
                let jobsAccepted = result["userdata"]["accepted"].arrayValue
                let jobsOffered = result["userdata"]["offered"].arrayValue
                let jobsHistory = result["userdata"]["history"].arrayValue
                
                self.allJobs.removeAll()
                self.thisTabJobs.removeAll()
                for job in jobsAccepted {
                    self.allJobs.append(Job(data: job))
                    if self.jobType == .accepted {
                        self.thisTabJobs.append(Job(data: job))
                    }
                }
                for job in jobsOffered {
                    self.allJobs.append(Job(data: job))
                    if self.jobType == .offered {
                        self.thisTabJobs.append(Job(data: job))
                    }
                }
                for job in jobsHistory {
                    self.allJobs.append(Job(data: job))
                    if self.jobType == .all {
                        self.thisTabJobs.append(Job(data: job))
                    }
                }
                
                self.jobCardCollection.reloadData()
                
                if self.thisTabJobs.count == 0 {
                    self.noJobsLabel.isHidden = false
                } else {
                    self.noJobsLabel.isHidden = true
                }
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
                self.showJobCard()
                
                self.removeSpinner()
                
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
    
    private func showJobCard() {
    
        // can we move to the view now?
        let preferences = UserDefaults.standard
        
        let currentLevelKey = "showJobIdCard"
        var showJobId = 0
        var sourceVC = ""
        if preferences.object(forKey: currentLevelKey) == nil {
            //  Doesn't exist
        } else {
            showJobId = preferences.integer(forKey: "showJobIdCard")
            sourceVC = preferences.string(forKey: "sourceAction") ?? ""
        }
        
        // always overwrite
        preferences.set(0, forKey: "showJobIdCard")
        preferences.set("", forKey: "sourceAction")
        preferences.synchronize()
        
        if showJobId != 0 && sourceVC != "" {
            var doSegue = false
            for job in self.allJobs {
                if (job.jobid == showJobId) {
                    self.performSegue(withIdentifier: "showJobDetailsSegue", sender: job)
                    doSegue = true
                }
            }
            if !doSegue {
                let appearance = SCLAlertView.SCLAppearance()
                let errorView = SCLAlertView(appearance: appearance)
                errorView.showError(
                    "Sorry",
                    subTitle: "That job is no longer available")
            }
        }
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
        return self.thisTabJobs.count > 0 ? 1:0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.thisTabJobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showJobDetailsSegue", sender: self.thisTabJobs[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "jobcell", for: indexPath) as! JobCardViewCVC
        
        cell.setRounded(radius: 20)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.FindaColours.Grey.cgColor

        cell.jobStatus.text(self.thisTabJobs[indexPath.row].header)
        cell.customerName.text(self.thisTabJobs[indexPath.row].companyName)
        
        cell.jobStatusColour.backgroundColor = UIColor.FindaColours.FindaRed
        cell.jobStatus.textColor = UIColor.FindaColours.Black
        
        let jobStatus = self.thisTabJobs[indexPath.row].header
        
        switch JobStatus(rawValue: jobStatus) {
            case .Requested?:
                cell.jobStatusColour.backgroundColor = UIColor.FindaColours.Blue
                cell.jobStatus.textColor = UIColor.FindaColours.Blue
                if self.thisTabJobs[indexPath.row].projectTid == 75 {
                    cell.jobStatus.text = "REQUESTED - CASTING"
                } else if self.thisTabJobs[indexPath.row].projectTid == 78 {
                    cell.jobStatus.text = "REQUESTED - GO & SEE"
                }
                break
            
            case .Accepted?:
                cell.jobStatusColour.backgroundColor = UIColor.FindaColours.Blue
                cell.jobStatus.textColor = UIColor.FindaColours.Blue
                cell.jobStatus.text("YOU ACCEPTED, AWAITING CLIENT CONFIRMATION")
                break
 
            case .Confirmed?:
                cell.jobStatusColour.backgroundColor = UIColor.FindaColours.FindaGreen
                cell.jobStatus.textColor = UIColor.FindaColours.FindaGreen
                
                if self.thisTabJobs[indexPath.row].jobcardType == "to complete" {
                    cell.jobStatus.text("TO COMPLETE")
                    cell.jobStatusColour.backgroundColor = UIColor.FindaColours.Black
                    cell.jobStatus.textColor = UIColor.FindaColours.Black
                }
                
                break
            
            case .ToComplete?:
                cell.jobStatusColour.backgroundColor = UIColor.FindaColours.Black
                cell.jobStatus.textColor = UIColor.FindaColours.Black
                cell.jobStatus.text = "TO COMPLETE"
                break
            
            case .ModelCompleted?, .Completed?, .ClientCompleted?:
                cell.jobStatusColour.backgroundColor = UIColor.FindaColours.Yellow
                cell.jobStatus.textColor = UIColor.FindaColours.Yellow
                cell.jobStatus.text("COMPLETED")
                break
            
            case .Expired?:
                cell.jobStatusColour.backgroundColor = UIColor.FindaColours.LighterGreen
                break
            
            case .Finished?:
                cell.jobStatusColour.backgroundColor = UIColor.FindaColours.Black
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
                break
        }
        
        cell.jobTitle.text = self.thisTabJobs[indexPath.row].name
        cell.jobType.text = self.thisTabJobs[indexPath.row].jobtype
        cell.jobDates.text = Date().displayDate(timeInterval: self.thisTabJobs[indexPath.row].startdate, format: "dd MMM")
        cell.jobTime.text = Date().displayDate(timeInterval: self.thisTabJobs[indexPath.row].starttime, format: "HH:mm")
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
}

var vSpinner: UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.clear // UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}


