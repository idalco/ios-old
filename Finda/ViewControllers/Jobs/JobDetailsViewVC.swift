//
//  ImageVC.swift
//  Finda
//
//  Created by Peter Lloyd on 31/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import UIKit
import DCKit
import SVProgressHUD
import SCLAlertView
import SafariServices
import Alamofire
import EventKit

class JobDetailsViewVC: UIViewController {
    
    
    @IBOutlet weak var clientLogo: UIImageView!
    
    @IBOutlet weak var jobStatus: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var jobType: UILabel!
    @IBOutlet weak var jobLocation: UILabel!
    @IBOutlet weak var jobDates: UILabel!
    @IBOutlet weak var jobTime: UILabel!
    
    @IBOutlet weak var agreedRate: UILabel!
    @IBOutlet var modelFee: UILabel!
    
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var jobLength: UILabel!
    
    @IBOutlet weak var negotiateButton: DCBorderedButton!
    @IBOutlet weak var advancedInfo: UILabel!
    @IBOutlet weak var advancedInfoStack: UIStackView!
    @IBOutlet weak var jobDescription: UILabel!
    
    @IBOutlet weak var primaryButton: DCBorderedButton!
    @IBOutlet weak var secondaryButton: DCBorderedButton!
    
    @IBOutlet weak var callsheetButton: DCBorderedButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var addToCalendar: UIImageView!
    
    var job: Job!
    
    var requestRefresh = false

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.barTintColor = UIColor.FindaColours.Blue
        
        customer.text = job.companyName.uppercased()
        
        jobStatus.text = job.header.uppercased()
        
        jobDates.text = Date().displayDate(timeInterval: job.startdate, format: "EEEE, MMM d, YYYY")
        jobTime.text = Date().displayDate(timeInterval: job.starttime, format: "h:mm a")

        
        jobDescription.text = job.description
        jobTitle.text = job.name.uppercased()
        jobType.text = job.jobtype.uppercased()
        jobLocation.text = job.location.uppercased()

        jobLength.text = JobsManager.length(length: job.timeUnits, unit: job.unitsType, altunit: job.altrateUnitsType).uppercased()
        
        let url = URL(string: "\(domainURL)/avatar/thumb\(job.avatar)")
        
        Alamofire.request(url!, method: .get)
            .validate()
            .responseData(completionHandler: { (responseData) in
                self.clientLogo.image = UIImage(data: responseData.data!)
                self.clientLogo.addSolidBorder(borderColour: UIColor.FindaColours.LighterGreen, cornerRadius: 48, width: 8)
            })
        
        if (job.contact_number != "") {
            contactNumber.isHidden = false
            contactNumber.text = "Contact: " + job.contact_number
        } else {
            contactNumber.isHidden = true
        }

        if (job.advanced != "") {
            advancedInfo.text = job.advanced
            advancedInfo.isHidden = false
        } else {
            advancedInfo.isHidden = true
            advancedInfoStack.height(0)
        }

        primaryButton.cornerRadius = 5
        secondaryButton.cornerRadius = 5

        if job.callsheet != "" {
            callsheetButton.isHidden = false
            callsheetButton.addTarget(self, action: #selector(downloadCallsheet(sender:)), for: .touchUpInside)
        }
        
        negotiateButton.isHidden = true
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(JobDetailsViewVC.backButtonTapped))
        backButton.addGestureRecognizer(tapRec)
        backButton.isUserInteractionEnabled = true
        
        let calRec = UITapGestureRecognizer(target: self, action: #selector(JobDetailsViewVC.addtoCalendarClicked))
        addToCalendar.addGestureRecognizer(calRec)
        addToCalendar.isUserInteractionEnabled = true
        
        addToCalendar.isHidden = true
        jobStatus.textColor = UIColor.FindaColours.FindaGreen
        
        // we may not use this, but set it up anyway
        var modelTotal = "Total for you: £"
        modelFee.isHidden = true
        
        if let jobHeaderStatus = JobStatus(rawValue: job.header) {

            switch(jobHeaderStatus) {

            case .Pending:

                break;

            case .Accepted:

                agreedRate.isHidden = false

                if job.unitsType == "unpaid" {
                    agreedRate.text = "Agreed consideration: \(job.altRate)"
                } else {
                    agreedRate.text = "Agreed rate:" + "£\(job.agreedRate)/\(job.unitsType.uppercased())"
                    
                    let calculatedFee = ((Double(job.agreedRate) * 0.9) * Double(job.timeUnits))
                    modelTotal = modelTotal + (NSString(format: "%.2f", calculatedFee) as String)
                    modelFee.text = modelTotal
                    modelFee.isHidden = false
                    
                }

                primaryButton.isHidden = true
                
                // 14 is accepted, 2 if confirmed, so we need to override here,
                // or refactor
                if job.status == 2 {
                    if job.jobcardType == "to complete" {
                        // this is an override funcvtion
                        secondaryButton.setTitle("COMPLETE", for: .normal)
                        secondaryButton.addTarget(self, action: #selector(completeJob(sender:)), for: .touchUpInside)

                        jobStatus.text = "TO COMPLETE"
                        jobStatus.textColor = UIColor.FindaColours.Black
                        
                        addToCalendar.isHidden = true
                    } else {
                        secondaryButton.setTitle("CANCEL", for: .normal)
                        secondaryButton.addTarget(self, action: #selector(cancelJob(sender:)), for: .touchUpInside)

                        jobStatus.text = "CONFIRMED"
                        addToCalendar.isHidden = false
                    }
                    
                } else {
                    secondaryButton.setTitle("CANCEL", for: .normal)
                    secondaryButton.addTarget(self, action: #selector(cancelJob(sender:)), for: .touchUpInside)
                }

                

                break
            case .ModelCompleted, .Completed, .ClientCompleted:
                primaryButton.isHidden = true
                secondaryButton.isHidden = true
                agreedRate.isHidden = false
                if job.unitsType == "unpaid" {
                    agreedRate.text = "Agreed consideration: \(job.altRate)"
                } else {
                    agreedRate.text = "Agreed rate:" + "£\(job.agreedRate)/\(job.unitsType.uppercased())"
                    
                    let calculatedFee = ((Double(job.agreedRate) * 0.9) * Double(job.timeUnits))
                    modelTotal = modelTotal + (NSString(format: "%.2f", calculatedFee) as String)
                    modelFee.text = modelTotal
                    modelFee.isHidden = false
                }

                jobStatus.textColor = UIColor.FindaColours.Yellow
                jobStatus.text = "COMPLETED"
                break
            case .Expired:
                primaryButton.isHidden = true
                secondaryButton.isHidden = true
                contactNumber.isHidden = true
                break
            case .Finished:
                primaryButton.setTitle("Waiting for Client to complete", for: .normal)
                primaryButton.isEnabled = false
                secondaryButton.isHidden = true
                contactNumber.isHidden = true
                break


            // not used
            case .Optioned:
                break


            case .Requested:
                var offeredLabel = "Offered rate: £"
                
                negotiateButton.isHidden = true
                negotiateButton.isEnabled = false
                negotiateButton.text("Negotiate")
                negotiateButton.addTarget(self, action: #selector(negotiateJob(sender:)), for: .touchUpInside)
                
                negotiateButton.layer.backgroundColor = UIColor.FindaColours.Blue.cgColor
                negotiateButton.setTitleColor(UIColor.white, for: .normal)
                negotiateButton.layer.borderColor = UIColor.FindaColours.Blue.cgColor
                negotiateButton.contentHorizontalAlignment = .center

                // if the type is a casting, hide these
                if job.projectTid != 75 && job.projectTid != 78 {
                    if (job.unitsType == "unpaid") {
                        offeredLabel = "Offered consideration: \(job.altRate)"
                        
                    } else {
                        if (job.agreedRate != 0) {
                            offeredLabel = "Agreed rate: £\(job.agreedRate)/\(job.unitsType.uppercased())"
                            
                            let calculatedFee = ((Double(job.agreedRate) * 0.9) * Double(job.timeUnits))
                            modelTotal = modelTotal + (NSString(format: "%.2f", calculatedFee) as String)
                            modelFee.text = modelTotal
                            modelFee.isHidden = false
                        } else {
                            
                            if job.clientOfferedRate != 0 {
                                offeredLabel = offeredLabel + "\(job.clientOfferedRate)"
                                let calculatedFee = ((Double(job.clientOfferedRate) * 0.9) * Double(job.timeUnits))
                                modelTotal = modelTotal + (NSString(format: "%.2f", calculatedFee) as String)
                                modelFee.text = modelTotal
                                modelFee.isHidden = false
                            } else {
                                offeredLabel = offeredLabel + "\(job.offeredRate)"
                                let calculatedFee = ((Double(job.offeredRate) * 0.9) * Double(job.timeUnits))
                                modelTotal = modelTotal + (NSString(format: "%.2f", calculatedFee) as String)
                                modelFee.text = modelTotal
                                modelFee.isHidden = false
                            }
                            offeredLabel = offeredLabel + "/\(job.unitsType.uppercased())"
                            
                            if job.modelDesiredRate != 0 {
                                offeredLabel = offeredLabel + "\nYou asked for: £\(job.modelDesiredRate)."
                            }

                            negotiateButton.isHidden = false
                            negotiateButton.isEnabled = true

                        }
                    }
                    
                    agreedRate.text = offeredLabel
                    agreedRate.isHidden = false
                } else {
                    // casting type
                    agreedRate.isHidden = true
                    if job.projectTid == 75 {
                        jobStatus.text = "CASTING"
                    } else if job.projectTid == 78 {
                        jobStatus.text = "GO & SEE"
                    }
                }

                primaryButton.isHidden = false
                primaryButton.setTitle("ACCEPT", for: .normal)
                primaryButton.addTarget(self, action: #selector(acceptJob(sender:)), for: .touchUpInside)
                secondaryButton.isHidden = false
                secondaryButton.setTitle("REJECT", for: .normal)
                secondaryButton.addTarget(self, action: #selector(rejectOption(sender:)), for: .touchUpInside)
                contactNumber.isHidden = true

                jobStatus.textColor = UIColor.FindaColours.Blue
                break

            case .Offered:
                break
            case .Unfinalised:
                primaryButton.setTitle("COMPLETE", for: .normal)
                secondaryButton.isHidden = true
                contactNumber.isHidden = true
                break

            case .Confirmed:
                
                if job.jobcardType == "to complete" {
                    // this is an override function
                    primaryButton.isHidden = true
                    secondaryButton.setTitle("COMPLETE", for: .normal)
                    secondaryButton.addTarget(self, action: #selector(completeJob(sender:)), for: .touchUpInside)
                    
                    jobStatus.text = "TO COMPLETE"
                    jobStatus.textColor = UIColor.FindaColours.Black
                    addToCalendar.isHidden = true
                } else {
                    primaryButton.isHidden = true
                    secondaryButton.setTitle("CANCEL", for: .normal)
                    secondaryButton.addTarget(self, action: #selector(cancelJob(sender:)), for: .touchUpInside)
                    
                    jobStatus.text = "CONFIRMED"
                    addToCalendar.isHidden = false
                }

                agreedRate.isHidden = false
                agreedRate.text = "Agreed rate: £\(job.agreedRate)/\(job.unitsType.uppercased())"
                
                modelTotal = modelTotal + (NSString(format: "%.2f", Double(job.agreedRate) * 0.9) as String)
                modelFee.text = modelTotal
                modelFee.isHidden = false
                
                break
            case .ToComplete:
                // this is an override function
//                primaryButton.isHidden = true
//                secondaryButton.setTitle("COMPLETE", for: .normal)
//                secondaryButton.addTarget(self, action: #selector(completeJob(sender:)), for: .touchUpInside)
//
//                agreedRate.isHidden = false
//                agreedRate.text = "Agreed rate: £\(job.agreedRate)/\(job.unitsType.uppercased())"
//
//                jobStatus.text = "TO COMPLETE"
//                jobStatus.textColor = UIColor.FindaColours.Black
//                addToCalendar.isHidden = true
                break
            }
        }
        
    
        addToCalendar.isHidden = true
    }
   
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.barTintColor = UIColor.FindaColours.LightGrey
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            FindaAPISession(target: .acceptJob(jobId: self.job.jobid)) { (response, result) in
                if response {
                    SVProgressHUD.dismiss()
                    self.dismiss(animated: true, completion: {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadJobs"), object: nil)
                    })
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
            FindaAPISession(target: .rejectJob(jobId: self.job.jobid)) { (response, result) in
                if response {
                    SVProgressHUD.dismiss()
                    self.dismiss(animated: true, completion: {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadJobs"), object: nil)
                    })
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
            FindaAPISession(target: .cancelJob(jobId: self.job.jobid)) { (response, result) in
                if response {
                    SVProgressHUD.dismiss()
                    self.dismiss(animated: true, completion: {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadJobs"), object: nil)
                    })
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
            FindaAPISession(target: .rejectOption(jobId: self.job.jobid)) { (response, result) in
                if response {
                    SVProgressHUD.dismiss()
                    self.dismiss(animated: true, completion: {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadJobs"), object: nil)
                    })
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
    
    @objc private func completeJob(sender: UIButton) {
        
        
        let appearance = SCLAlertView.SCLAppearance()
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("Complete Job") {
            SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Blue)
            SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
            SVProgressHUD.show()
            FindaAPISession(target: .completeJob(jobId: self.job.jobid)) { (response, result) in
//            FindaAPISession(target: .cancelJob(jobId: self.job.jobid)) { (response, result) in
                if response {
                    SVProgressHUD.dismiss()
                    self.dismiss(animated: true, completion: {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadJobs"), object: nil)
                    })
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
    
    @objc private func downloadCallsheet(sender: UIButton) {
        
        if let url = URL(string: "https://finda.co/download/callsheet/\(job.jobid)") {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self.parent as? SFSafariViewControllerDelegate
        }
        
    }
    
    @objc private func negotiateJob(sender: UIButton) {
        
        let appearance = SCLAlertView.SCLAppearance()
        let alertView = SCLAlertView(appearance: appearance)
        let newRateField = alertView.addTextField("Enter your desired rate")
        
        var heightOffset = 0
        let heightStep = 38

        // @TODO this needs to be a dynamic list
        let subview = UIView(frame: CGRect(x: 0, y: 0, width: 216, height: heightStep * 5))

        var subtitle = "The current offered rate is: £"
        if job.clientOfferedRate != 0 {
            subtitle = subtitle + "\(job.clientOfferedRate)"
        } else {
            subtitle = subtitle + "\(job.offeredRate)"
        }
        subtitle = subtitle + "/" + job.unitsType + "."
        
        if job.modelDesiredRate != 0 {
            subtitle = subtitle + "\nYou asked for: £\(job.modelDesiredRate)."
        }
        
        let textReason = UITextView(frame: CGRect(x: 0, y: heightOffset, width: 216, height: heightStep))
        textReason.text = "Reason for negotiation"
        textReason.textAlignment = NSTextAlignment.center
        textReason.font = UIFont(name: "Gotham-Medium", size: 12)
        subview.addSubview(textReason)
        
        heightOffset = heightOffset + heightStep
        
        let textfield1 = UITextView(frame: CGRect(x: 0, y: heightOffset, width: 164, height: heightStep))
        textfield1.text = "For selected usage rights the rate is too low"
        textfield1.textAlignment = NSTextAlignment.left
        subview.addSubview(textfield1)
        let switch1 = UISwitch(frame:CGRect(x: 165, y: heightOffset + 4, width: 0, height: heightStep))
        switch1.setOn(false, animated: false)
        switch1.tintColor = UIColor.FindaColours.Blue
        switch1.onTintColor = UIColor.FindaColours.Blue
        switch1.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        subview.addSubview(switch1)

        heightOffset = heightOffset + heightStep
        
        let textfield2 = UITextView(frame: CGRect(x: 0, y: heightOffset, width: 164, height: heightStep))
        textfield2.text = "My negotiated rate is my minimum for this type of job"
        textfield2.textAlignment = NSTextAlignment.left
        subview.addSubview(textfield2)
        let switch2 = UISwitch(frame:CGRect(x: 165, y: heightOffset + 4, width: 0, height: heightStep))
        switch2.setOn(false, animated: false)
        switch2.tintColor = UIColor.FindaColours.Blue
        switch2.onTintColor = UIColor.FindaColours.Blue
        switch2.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        subview.addSubview(switch2)

        heightOffset = heightOffset + heightStep
        
        let textfield3 = UITextView(frame: CGRect(x: 0, y: heightOffset, width: 164, height: heightStep))
        textfield3.text = "My usual rate for this type of job is higher"
        textfield3.textAlignment = NSTextAlignment.left
        subview.addSubview(textfield3)
        let switch3 = UISwitch(frame:CGRect(x: 165, y: heightOffset + 4, width: 0, height: heightStep))
        switch3.setOn(false, animated: false)
        switch3.tintColor = UIColor.FindaColours.Blue
        switch3.onTintColor = UIColor.FindaColours.Blue
        switch3.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        subview.addSubview(switch3)
        
        heightOffset = heightOffset + heightStep

        let textSubtitle = UITextView(frame: CGRect(x: 0, y: heightOffset, width: 216, height: heightStep * 2))
        textSubtitle.text = subtitle
        textSubtitle.textAlignment = NSTextAlignment.center
        textSubtitle.font = UIFont(name: "Gotham-Bold", size: 12)
        subview.addSubview(textSubtitle)
    
        alertView.customSubview = subview
        
        alertView.addButton("Negotiate") {
            // the value we need is in newRate
            let newRate = Int(newRateField.text!)

            // get the switch reasons here
            // @TODO this needs to be a dynamic list
            var reasons: [Int] = []
            
            if switch1.isOn {
                reasons.append(87)
            }
            
            if switch2.isOn {
                reasons.append(91)
            }
            
            if switch3.isOn {
                reasons.append(88)
            }
            
            SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Blue)
            SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
            SVProgressHUD.show()
            FindaAPISession(target: .negotiateRate(jobId: self.job.jobid, newRate: newRate!, reasons: reasons)) { (response, result) in
                if response {
                    SVProgressHUD.dismiss()
                    let noticeView = SCLAlertView(appearance: appearance)
                    noticeView.showInfo("Negotiation Sent", subTitle: "The Client should respond shortly", colorStyle: 0x13AFC0)
                    
                    var offeredLabel = "Offered rate: £"
                    
                    if (self.job.agreedRate != 0) {
                        self.agreedRate.text = "Agreed rate: £\(self.job.agreedRate)/\(self.job.unitsType.uppercased())"
                    } else {
                        
                        if self.job.clientOfferedRate != 0 {
                            offeredLabel = offeredLabel + "\(self.job.clientOfferedRate)"
                        } else {
                            offeredLabel = offeredLabel + "\(self.job.offeredRate)"
                        }
                        offeredLabel = offeredLabel + "/\(self.job.unitsType.uppercased())"
                        
                        
                    }
                    
                    offeredLabel = offeredLabel + "\nYou asked for: £\(newRate ?? self.job.modelDesiredRate)."
                    self.agreedRate.text = offeredLabel
                    self.requestRefresh = true
                    
                } else {
                    SVProgressHUD.dismiss()
                    let errorView = SCLAlertView(appearance: appearance)
                    errorView.showError(
                        "Sorry",
                        subTitle: "Something went wrong sending your negotiation. Please try again later.")
                }
            }
        }
        
        alertView.showTitle(
            "Negotiate Rate",
            subTitle: subtitle,
            style: .question,
            closeButtonTitle: "Cancel",
            colorStyle: 0x13AFC0,
            colorTextButton: 0xFFFFFF)
        
    }

    @objc private func backButtonTapped(sender: UIImageView) {
        if self.requestRefresh {
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadJobs"), object: nil)
            })
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func addtoCalendarClicked(sender: UIImageView) {
        
        let appearance = SCLAlertView.SCLAppearance()
    
        var duration = self.job.timeUnits
        if self.job.unitsType == "day" {
            duration = duration * 60*60*24
        } else if self.job.unitsType == "hour" {
            duration = duration * 60*60
        }
    
        let startDate = Date(timeIntervalSince1970: Double(self.job.startdate))
        let startTime = Date(timeIntervalSince1970: Double(self.job.starttime))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let startDateString = dateFormatter.string(from: startDate)
        dateFormatter.dateFormat = "HH:mm"
        let startTimeString = dateFormatter.string(from: startTime)
        let startString = startDateString + " " + startTimeString
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let calStartDate = dateFormatter.date(from: startString)
    
        let end = Double(self.job.startdate + Int(duration))
        let calEndDate = Date(timeIntervalSince1970: end)
        
        addEventToCalendar(title: self.job.name, description: self.job.description, startDate: calStartDate!, endDate: calEndDate)
        addToCalendar.isHidden = true
        let noticeView = SCLAlertView(appearance: appearance)
        noticeView.showInfo("Added!", subTitle: "The job has been added to your calendar", colorStyle: 0x13AFC0)
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        DispatchQueue.main.async { () -> Void in
            let eventStore = EKEventStore()
            
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: eventStore)
                    event.title = title
                    event.startDate = startDate
                    event.endDate = endDate
                    event.notes = description
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch let e as NSError {
                        completion?(false, e)
                        return
                    }
                    completion?(true, nil)
                } else {
                    completion?(false, error as NSError?)
                }
            })
        }
    }
    
}
