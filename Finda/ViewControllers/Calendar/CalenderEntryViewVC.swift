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
import QVRWeekView

class CalendarEntryViewVC: UIViewController {
    
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayView: WeekView!
    @IBOutlet weak var todayButton: UIButton!
    
    var calendarEntry: CalendarEntry!
    
    var dayEntries: [CalendarEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(CalendarEntryViewVC.backButtonTapped))
        backButton.addGestureRecognizer(tapRec)
        backButton.isUserInteractionEnabled = true
        
        // https://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        // because this isn't on the Apple website anywhere
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        
        dateLabel.text = "Entries for " + formatter.string(from: Date(timeIntervalSince1970: calendarEntry!.starttime))
        
        // format the day view
        dayView.mainBackgroundColor = UIColor.FindaColours.LightGreen
        dayView.defaultTopBarHeight = 32.0
        dayView.topBarColor = UIColor.FindaColours.LightGreen
        dayView.visibleDaysInPortraitMode = 1
        dayView.dayViewMainSeparatorColor = UIColor.FindaColours.BorderGrey
        dayView.dayViewDashedSeparatorColor = UIColor.FindaColours.BorderGrey
        
        todayButton.addTarget(self, action: #selector(moveToToday(sender:)), for: .touchUpInside)
        
        loadEntriesForDate()

    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
   
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func backButtonTapped(sender: UIImageView) {
        self.dismiss(animated: true)
    }
    
    @objc func moveToToday(sender: Any) {
        self.dayView.showDay(withDate: Date(timeIntervalSince1970: calendarEntry!.starttime))
    }
    
    func loadEntriesForDate() {
        CalendarEntryManager.getCalendarEntriesForDate(date: calendarEntry!.starttime) { (response, result, calendarEntries) in
            
            if response {
                self.dayEntries = calendarEntries
                self.refreshDayView()
            } else {
                // show error
            }
        }
    }
    
    
    
    /*
     * removes all subviews from the container, and rebuilds from an XIB to show the entries
     */
    func refreshDayView() {
        
        if dayEntries.count != 0 {
            self.dayView.showDay(withDate: Date(timeIntervalSince1970:  dayEntries.first!.starttime))
        
            var allEvents: [Int: EventData] = [:]
            var eventIndex: Int = 0
            for entry in dayEntries {
                
                var colour: UIColor
                if entry.jobid == 0 {
                   colour = UIColor.FindaColours.LightGrey
                } else {
                    colour = UIColor.FindaColours.Blue
                }
                
                let newEvent = EventData(id: entry.id,
                                         title: entry.title,
                                         startDate: Date(timeIntervalSince1970: entry.starttime),
                                         endDate: Date(timeIntervalSince1970: entry.endtime),
                                         location: entry.location,
                                         color: colour,
                                         allDay: entry.isAllDay)
                allEvents[eventIndex] = newEvent
                eventIndex += 1
                
                
//                if (entry.jobid == 0) {
//                    // normal entry
//                    let subview: DayEntry = .fromNib()
//
//                    subview.eventTime.text = Date().displayDate(timeInterval: Int(entry.starttime), format: "h:mm a")
//                    subview.eventTitle.text = entry.title
//                    subview.eventLocation.text = entry.location
//                    subview.addSolidBorder(borderColour: UIColor.FindaColours.Blue)
//                    subview.layoutIfNeeded()
//                    self.entryHolder.addSubview(subview)
//                } else {
//                    // job-type entry
//                    let subview: DayEntryWithJob = .fromNib()
//
//                    subview.callTime.text = Date().displayDate(timeInterval: Int(entry.starttime), format: "h:mm a")
//                    subview.entryTitle.text = entry.title
//                    subview.customerName.text = entry.clientCompany
//                    subview.jobLocation.text = entry.location
//                    subview.jobStatus.text = entry.jobtypeDescription
//                    subview.jobStatus.textColor = UIColor.FindaColours.Blue
//                    subview.addSolidBorder(borderColour: UIColor.FindaColours.Blue)
//                    subview.layoutIfNeeded()
//                    subview.frame.size.height = subview.viewWithTag(0)!.frame.height + 16
//                    self.entryHolder.addSubview(subview)
//
//                }
                
            }
            dayView.loadEvents(withData: Array(allEvents.values))
            
        } else {
//            // show error label
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: 160, y: 285)
            label.textAlignment = .center
            label.text = "No events for today"
//            self.entryHolder.addSubview(label)
            self.dayView.isHidden = true
        }
    }
    
}

//extension UIView {
//    class func fromNib<T: UIView>() -> T {
//        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
//    }
//}

