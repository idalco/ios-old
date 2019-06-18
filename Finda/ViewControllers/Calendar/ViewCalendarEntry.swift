//
//  ViewCalendarEntry.swift
//  Finda
//
//  Created by cro on 04/06/2019.
//  Copyright © 2019 Finda Ltd. All rights reserved.
//

import Foundation
import SCLAlertView
import SVProgressHUD
import DCKit

class ViewCalendarEntry: UIViewController {
    
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryCustomer: UILabel!
    @IBOutlet weak var entryDates: UILabel!
    @IBOutlet weak var entryLocation: UILabel!
    @IBOutlet var editEntryButton: DCBorderedButton!
    @IBOutlet var deleteEntryButton: DCBorderedButton!
    
    @IBOutlet weak var jobDetailsView: UIView!
    @IBOutlet weak var jobType: UILabel!
    @IBOutlet weak var viewJobButton: DCBorderedButton!
    
    var calendarEntry: CalendarEntry = CalendarEntry(data: [])  {
        didSet
        {
            if let _ = view, self.isViewLoaded {
                renderData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(ViewCalendarEntry.backButtonTapped))
        backButton.addGestureRecognizer(tapRec)
        backButton.isUserInteractionEnabled = true
        
        viewJobButton.addTarget(self, action: #selector(showJob), for: .touchUpInside)
        
        editEntryButton.addTarget(self, action: #selector(editEntry), for: .touchUpInside)
        deleteEntryButton.addTarget(self, action: #selector(deleteEntry), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(closeModal),
                                               name: NSNotification.Name(rawValue: "dismissViewCalendarPopup"),
                                               object: nil)
    }
    
    @objc func closeModal() {
        self.dismiss(animated: true)
    }
    
    @objc func showJob() {
        self.dismiss(animated: true, completion: {
            let preferences = UserDefaults.standard
            preferences.set("tappedNotification", forKey: "sourceAction")
            preferences.set(self.calendarEntry.jobid, forKey: "showJobIdCard")
            preferences.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "calendarEventToJobCard"), object: nil)
        })
    }
    
    @objc private func backButtonTapped(sender: UIImageView) {
        self.dismiss(animated: true)
    }
    
    @objc func renderData() {
        
        entryTitle.text = calendarEntry.title
        var displayDates = calendarEntry.startDate
        if calendarEntry.startDate != calendarEntry.endDate {
            displayDates = " to " + calendarEntry.endDate
        }
        entryDates.text = displayDates
        entryLocation.text = calendarEntry.location
        
        
        if calendarEntry.jobid != 0 {
            jobDetailsView.isHidden = false
            jobType.text = calendarEntry.jobtypeDescription
            entryCustomer.text = calendarEntry.clientCompany
            editEntryButton.isHidden = true
        } else {
            jobDetailsView.isHidden = true
            entryCustomer.isHidden = true
            editEntryButton.isHidden = false
        }
        
    }
    
    @objc func editEntry() {
        performSegue(withIdentifier: "editCalendarEntrySegue", sender: calendarEntry)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editCalendarEntrySegue") {
            let vc = segue.destination as? NewCalendarEntry
            if let entry = sender as? CalendarEntry {
                vc?.calendarEntry = entry
            }
        }
    }
    
    @objc func deleteEntry() {
        
        
        let appearance = SCLAlertView.SCLAppearance()
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("Delete Event") {
            SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Blue)
            SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
            SVProgressHUD.show()
            
            let scheduleId = self.calendarEntry.scheduleId
            CalendarEntryManager.deleteCalendarEntry(scheduleId: scheduleId) { (response, result) in
                if response {
                    SVProgressHUD.dismiss()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCalendar"), object: nil)
                    self.dismiss(animated: true)
                } else {
                    // show error
                    let appearance = SCLAlertView.SCLAppearance()
                    let errorView = SCLAlertView(appearance: appearance)
                    errorView.showError(
                        "Sorry",
                        subTitle: "There was a problem deleting your calendar entry.")
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

}

