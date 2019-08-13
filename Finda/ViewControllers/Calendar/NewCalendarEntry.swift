//
//  NewCalendarEntry.swift
//  Finda
//
//  Created by cro on 04/06/2019.
//  Copyright © 2019 Finda Ltd. All rights reserved.
//

import Foundation
import Eureka
import SCLAlertView
import SVProgressHUD

class NewCalendarEntry: FormViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var editLabel: UILabel!
    
    public var calendarEntry: CalendarEntry = CalendarEntry(date: Date().timeIntervalSince1970) {
        didSet
        {
            if let _ = view, self.isViewLoaded {
                renderData()
                isBeingEdited = true
                editLabel.text = "Edit Calendar Entry"
            }
        }
    }
    
    var isBeingEdited: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(NewCalendarEntry.backButtonTapped))
        backButton.addGestureRecognizer(tapRec)
        backButton.isUserInteractionEnabled = true
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped(sender:)), for: .touchUpInside)
        
        form +++ Section("Event Title")
        <<< TextRow() { row in
            row.value = calendarEntry.title
            row.tag = "eventtitle"
            row.add(rule: RuleRequired())
            row.validationOptions = .validatesOnChangeAfterBlurred
            row.cell.backgroundColor = UIColor.FindaColours.White
        }
        .cellUpdate { cell, row in
            if !row.isValid {
                cell.textLabel?.textColor = .red
                
            }
        }
        .onCellHighlightChanged({ (textCell, textRow) in
            if textRow.isHighlighted {
                textCell.backgroundColor = UIColor.FindaColours.LightGrey
            } else {
                textCell.backgroundColor = UIColor.FindaColours.White
            }
        })
            
        +++ Section("Date & Time")
        <<< SwitchRow("allday") { row in
            row.title = "All day?"
            row.tag = "allday"
            row.cell.switchControl.onTintColor = UIColor.FindaColours.Burgundy
            row.cell.backgroundColor = UIColor.FindaColours.White
        }
        .cellSetup({ (SwitchCell, SwitchRow) in
            if self.calendarEntry.isAllDay {
                (self.form.rowBy(tag: "allday") as? SwitchRow)?.cell.switchControl.isOn = true
            }
            self.tableView.reloadData()
        })
            
        <<< DateTimeRow("From") { row in
            row.title = "From"
            row.tag = "startdate"
            row.minuteInterval = 15
            row.value = Date(timeIntervalSince1970: calendarEntry.starttime)
            row.hidden = Condition.function(["allday"], { form in
                return ((form.rowBy(tag: "allday") as? SwitchRow)?.value ?? false)
            })
            row.cell.backgroundColor = UIColor.FindaColours.White
            
        }
        .cellSetup({ (dateCell, dateTimeRow) in
            dateTimeRow.dateFormatter?.dateStyle = .short
            dateTimeRow.dateFormatter?.timeStyle = .short
            dateCell.row.value = Date(timeIntervalSince1970: self.calendarEntry.starttime)
            
        })
        .onChange({ row in
            let untilRow = self.form.rowBy(tag: "enddate") as! DateTimeRow
            untilRow.minimumDate = row.value! + (60*60)
            untilRow.value = row.value! + (60*60)
            untilRow.reload()
        })
            
        <<< DateTimeRow("Until") { row in
            row.title = "Until"
            row.tag = "enddate"
            row.minuteInterval = 15
            row.value = Date(timeIntervalSince1970: calendarEntry.endtime)
            row.hidden = Condition.function(["allday"], { form in
                return ((form.rowBy(tag: "allday") as? SwitchRow)?.value ?? false)
            })
            row.cell.backgroundColor = UIColor.FindaColours.White

        }
        .cellSetup({ (dateCell, dateTimeRow) in
            dateTimeRow.dateFormatter?.dateStyle = .short
            dateTimeRow.dateFormatter?.timeStyle = .short
            if self.isBeingEdited {
                dateCell.row.value = Date(timeIntervalSince1970: self.calendarEntry.endtime)
                dateTimeRow.minimumDate = Date(timeIntervalSince1970: self.calendarEntry.starttime + (60*60))
            } else {
                dateCell.row.value = Date(timeIntervalSince1970: self.calendarEntry.starttime + (60*60))
                dateTimeRow.minimumDate = Date(timeIntervalSince1970: self.calendarEntry.starttime + (60*60))
            }
        })
            
        +++ Section("Will you be available for bookings?")
        <<< SegmentedRow<String>() { row in
            row.tag = "freebusy"
            row.options = ["Yes", "No"]
            row.value = "No"
            row.cell.backgroundColor = UIColor.FindaColours.White
            row.cell.tintColor = UIColor.FindaColours.Burgundy
        }
            
        +++ Section("Private notes to yourself")
        <<< TextRow() { row in
            row.value = calendarEntry.location
            row.tag = "location"
            row.cell.backgroundColor = UIColor.FindaColours.White
        }
        .onCellHighlightChanged({ (textCell, textRow) in
            if textRow.isHighlighted {
                textCell.backgroundColor = UIColor.FindaColours.LightGrey
            } else {
                textCell.backgroundColor = UIColor.FindaColours.White
            }
        })
        
        self.tableView?.backgroundColor = UIColor.FindaColours.White

    }
    
    @objc private func backButtonTapped(sender: UIImageView) {
        self.dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped(sender: UIImageView) {
        
        let values = form.values()
        var starttime: Double = Date().timeIntervalSince1970
        var endtime: Double = Date().timeIntervalSince1970

        let eventTitle = values["eventtitle"] as! String
        let allDay = (values["allday"] as? Bool) ?? false
        if !allDay {
            let startdate = values["startdate"] as! Date
            starttime = startdate.timeIntervalSince1970
            let enddate = values["enddate"] as! Date
            endtime = enddate.timeIntervalSince1970
        }
        
        let location = values["location"] as! String
        
        let selectedState = values["freebusy"] as! String
        
        var state = "Busy"
        if selectedState == "Yes" {
            state = "Free"
        }
        
        if eventTitle != "" {
            if isBeingEdited {
                FindaAPISession(target: .updateCalendarEntry(scheduleId: calendarEntry.scheduleId, title: eventTitle, allday: allDay, starttime: starttime, endtime: endtime, location: location, state: state)) { (response, result) in
                    if response {
                        
                        // send semaphore back that event was saved so we can reload later
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateEventsDisplay"), object: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissViewCalendarPopup"), object: nil)
                        self.dismiss(animated: true)
                    } else {
                        let appearance = SCLAlertView.SCLAppearance()
                        let errorView = SCLAlertView(appearance: appearance)
                        errorView.showError(
                            "Sorry",
                            subTitle: "There was a problem saving your calendar entry.")
                    }
                }
            } else {
                FindaAPISession(target: .newCalendarEntry(title: eventTitle, allday: allDay, starttime: starttime, endtime: endtime, location: location, state: state, isediting: isBeingEdited)) { (response, result) in
                    if response {
                        
                        // send semaphore back that event was saved so we can reload later
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateEventsDisplay"), object: nil)
                        
//                        let updatedEntry: CalendarEntry = CalendarEntry(title: eventTitle, allday: allDay, starttime: starttime, endtime: endtime, location: location, state: state, scheduleid: self.calendarEntry.scheduleId, userid: self.calendarEntry.userid)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissViewCalendarPopup"), object: nil)
                        
                        self.dismiss(animated: true)
                    } else {
                        let appearance = SCLAlertView.SCLAppearance()
                        let errorView = SCLAlertView(appearance: appearance)
                        errorView.showError(
                            "Sorry",
                            subTitle: "There was a problem saving your calendar entry.")
                    }
                }
            }
        } else {
            let appearance = SCLAlertView.SCLAppearance()
            let errorView = SCLAlertView(appearance: appearance)
            errorView.showError(
                "Sorry",
                subTitle: "You must provide a title for this entry.")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCalendar"), object: nil)
        
//        let updatedEntry: CalendarEntry = CalendarEntry(title: eventTitle, allday: allDay, starttime: starttime, endtime: endtime, location: location, state: state, scheduleid: calendarEntry.scheduleId, userid: calendarEntry.userid)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissViewCalendarPopup"), object: nil)
    }
    
    func validateRow(tag: String){
        let row: BaseRow? = form.rowBy(tag: tag)
        _ = row?.validate()
    }
    
    func renderData() {
        form.rowBy(tag: "eventtitle")!.value = calendarEntry.title
        form.rowBy(tag: "location")!.value = calendarEntry.location
        form.rowBy(tag: "freebusy")!.value = calendarEntry.state
        form.rowBy(tag: "startdate")!.value = Date(timeIntervalSince1970: calendarEntry.starttime)
        form.rowBy(tag: "enddate")!.value = Date(timeIntervalSince1970: calendarEntry.endtime)
        (self.form.rowBy(tag: "allday") as? SwitchRow)?.value = calendarEntry.isAllDay
        if calendarEntry.isAllDay {
            (self.form.rowBy(tag: "allday") as? SwitchRow)?.cell.switchControl.isOn = true
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView?.backgroundColor = UIColor.FindaColours.White
            view.textLabel?.backgroundColor = UIColor.clear
            view.textLabel?.textColor = UIColor.FindaColours.Black
            view.textLabel?.font = UIFont(name: "Montserrat-Medium", size: 16)
        }
    }
    
}

