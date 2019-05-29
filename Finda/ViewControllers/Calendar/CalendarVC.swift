//
//  CalendarVC.swift
//  Finda
//
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
//import Eureka
import SVProgressHUD
import DCKit
import JTAppleCalendar

class CalendarVC: UIViewController {
    
 
    @IBOutlet weak var availabilityToggle: UISwitch!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var todayButton: UIButton!
    
    var calendarDataSource: [String:CalendarEntry] = [:]
    
    var dateformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let modelManager = ModelManager()
        
        let availability = modelManager.available()
        
        if availability  == true {
            availabilityToggle.isOn = true
        } else {
            availabilityToggle.isOn = false
        }
        
        availabilityToggle.addTarget(self, action: #selector(toggleAvailability(sender:)), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.scrollDirection = .horizontal
        calendarView.showsHorizontalScrollIndicator = false
        
        todayButton.addTarget(self, action: #selector(moveToToday(sender:)), for: .touchUpInside)
        
        loadUserCalendar()
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellEvents(cell: cell, cellState: cellState)
    }
    
    func loadUserCalendar() {
        // You can get the data from a server.
        // Then convert that data into a form that can be used by the calendar.
//        calendarDataSourceOld = [
//            "07-Jan-2018": "SomeData",
//            "15-Jan-2018": "SomeMoreData",
//            "15-Feb-2018": "MoreData",
//            "21-Feb-2018": "onlyData",
//        ]
        
        CalendarEntryManager.getCalendarEntries { (response, result, calendarEntries) in
            
            if response {
                for entry in calendarEntries {
                    self.calendarDataSource[entry.startDate] = entry
                }
                // update the calendar
                self.calendarView.reloadData()
            } else {
                // show error
            }
        }
        
        
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.FindaColours.Black
        } else {
            cell.dateLabel.textColor = UIColor.FindaColours.Grey
        }
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.layer.cornerRadius =  5
            cell.selectedView.isHidden = false
            if cell.hasData {
                self.performSegue(withIdentifier: "editCalendarSegue", sender: cell.calendarEntry)
            }
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
    func handleCellEvents(cell: DateCell, cellState: CellState) {
        let dateString = dateformatter.string(from: cellState.date)
        
        if calendarDataSource[dateString] == nil {
            cell.dotView.isHidden = true
            cell.hasData = false
        } else {
            cell.dotView.isHidden = false
            cell.calendarEntry = self.calendarDataSource[dateString]!
            cell.hasData = true
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let formatter = DateFormatter()
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        
        formatter.dateFormat = "MMM"
        header.monthTitle.text = formatter.string(from: range.start)
        
        formatter.dateFormat = "yyyy"
        header.yearTitle.text = formatter.string(from: range.start)
        
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func toggleAvailability(sender: UISwitch) {
        var available = 0
        if availabilityToggle.isOn {
            available = 1
        }
        
        FindaAPISession(target: .updateAvailability(availability: available)) { (response, result) in
            if response {
                if available == 1 {
                    self.calendarView.alpha = 1.0
                } else {
                    self.calendarView.alpha = 0.2
                }
            } else {
                SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Blue)
                SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
                SVProgressHUD.showError(withStatus: "There was a problem saving your availability")
            }
        }
    }
    
    @objc func moveToToday(sender: Any) {
        self.calendarView.scrollToDate(Date())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}

extension CalendarVC: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
//        let formatter = DateFormatter()
//        self.formatter.dateFormat = "dd-MMM-yyyy"
        let startDate = dateformatter.date(from: "01-aug-2018")!
        let endDate = Date()
        return ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            numberOfRows: 6,
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .sunday,
            hasStrictBoundaries: true
        )
    }
    

    
}
extension CalendarVC: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editCalendarSegue") {
            let vc = segue.destination as? CalendarEntryViewVC
            vc?.calendarEntry = sender as? CalendarEntry
        }
    }
}
