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

class CalendarEntryViewVC: UIViewController, WeekViewDelegate {
    
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var dayView: WeekView!
    @IBOutlet weak var todayButton: UIButton!
    
    var calendarEntry: CalendarEntry!
    
    var dayEntries: [CalendarEntry] = []
//    var allEntries: [String: CalendarEntry] = [:]
    
    var allEvents: [String: EventData] = [:]
    var showDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(CalendarEntryViewVC.backButtonTapped))
        backButton.addGestureRecognizer(tapRec)
        backButton.isUserInteractionEnabled = true
        
        // https://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        // because this isn't on the Apple website anywhere
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        
        // format the day view
        dayView.mainBackgroundColor = UIColor.FindaColours.LightGrey
        dayView.defaultTopBarHeight = 32.0
        dayView.topBarColor = UIColor.FindaColours.LightGrey
        dayView.visibleDaysInPortraitMode = 1
        dayView.dayViewMainSeparatorColor = UIColor.FindaColours.BorderGrey
        dayView.dayViewDashedSeparatorColor = UIColor.FindaColours.BorderGrey
        
        todayButton.addTarget(self, action: #selector(moveToToday(sender:)), for: .touchUpInside)
        todayButton.tintColor = UIColor.FindaColours.Black
        self.showDate = calendarEntry!.startDate
        self.refreshDayView()
        dayView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadEvents), name: NSNotification.Name(rawValue: "UpdateEventsDisplay"), object: nil)

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
        self.dayView.showDay(withDate: Date())
    }
    
    /*
     * removes all subviews from the container, and rebuilds from an XIB to show the entries
     */
    func refreshDayView() {
        self.dayView.showDay(withDate: Date(timeIntervalSince1970:  calendarEntry.starttime))
        
        if dayEntries.count != 0 {
            allEvents.removeAll()
            for (entry) in dayEntries {
                var colour: UIColor
                // personal
                if entry.jobid == 0 {
                    if entry.state == "Busy" {
                        colour = UIColor.FindaColours.Pink.lighter(by: 20)!
                    } else {
                        colour = UIColor.FindaColours.LightGrey
                    }
                    
                // Finda job
                } else {
                    colour = UIColor.FindaColours.Burgundy.lighter(by: 20)!
                }
                
                // make events at least 1 hour long so they show up
                var endTime: Double
                if entry.endtime < entry.starttime + (60*60) {
                    endTime = entry.starttime + (60*60)
                } else {
                    endTime = entry.endtime
                }
                
                let newEvent = EventData(id: entry.scheduleId, // entry.id,
                    title: entry.title,
                    startDate: Date(timeIntervalSince1970: entry.starttime),
                    endDate: Date(timeIntervalSince1970: endTime),
                    location: entry.location,
                    color: colour,
                    allDay: entry.isAllDay)
                
                allEvents[entry.scheduleId] = newEvent
            }
            dayView.loadEvents(withData: Array(allEvents.values))
        }
        
    }
    
    func didTapEvent(in dayView: WeekView, withId eventId: String) {
        var thisTappedEvent: EventData?
        var thisCalendarEntry: CalendarEntry?

        thisTappedEvent = allEvents[eventId]
        
        for entry in dayEntries {
            if entry.scheduleId == eventId {
                thisCalendarEntry = entry
            }
        }
        
        
        let alert = UIAlertController(title: "\(thisTappedEvent!.title)", message: "\(thisTappedEvent!.location)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        if thisCalendarEntry != nil {
            if thisCalendarEntry!.jobid != 0 {
                alert.addAction(UIAlertAction(title: "View Job", style: .default, handler: { (_) in
                    self.dismiss(animated: true, completion: {
                        let preferences = UserDefaults.standard
                        preferences.set("tappedNotification", forKey: "sourceAction")
                        preferences.set(thisCalendarEntry!.jobid, forKey: "showJobIdCard")
                        preferences.synchronize()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "calendarEventToJobCard"), object: nil)
                    })
                }))
            } else {
                alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_) in
                    self.editEntry(entry: thisCalendarEntry!)
                }))
                alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (_) in
                    self.deleteCalendarEntry(scheduleId: eventId)
                }))
            }
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func didLongPressDayView(in dayView: WeekView, atDate date: Date) {
        performSegue(withIdentifier: "newCalendarEntrySegue", sender: self)
    }
    
    func eventLoadRequest(in weekView: WeekView, between startDate: Date, and endDate: Date) {
        
    }
    
    func editEntry(entry: CalendarEntry) {
        performSegue(withIdentifier: "newCalendarEntrySegue", sender: entry)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "newCalendarEntrySegue") {
            let vc = segue.destination as? NewCalendarEntry
            if let entry = sender as? CalendarEntry {
                vc?.calendarEntry = entry
            }
        }
    }
    
    @objc func reloadEvents() {
        CalendarEntryManager.getCalendarEntries { (response, result, calendarEntries) in
            if response {
                self.dayEntries.removeAll()
                for entry in calendarEntries {
                    self.dayEntries.append(entry)
                }
                // update the calendar
                self.refreshDayView()
            } else {
                // show error
                let appearance = SCLAlertView.SCLAppearance()
                let errorView = SCLAlertView(appearance: appearance)
                errorView.showError(
                    "Sorry",
                    subTitle: "There was a problem reloading your calendar.")
            }
        }
    }
    
    func deleteCalendarEntry(scheduleId: String) {
        CalendarEntryManager.deleteCalendarEntry(scheduleId: scheduleId) { (response, result) in
            if response {
                self.reloadEvents()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCalendar"), object: nil)
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
    
}
