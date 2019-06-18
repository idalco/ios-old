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
import SideMenuSwift

class CalendarVC: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    
    struct DayViewData {
        var date = String()
        var calendar = [CalendarEntry]()
    }
 
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var todayList: UITableView!
    @IBOutlet weak var todayListLabel: UILabel!
    
    var calendarDataSource: [String:CalendarEntry] = [:]
    
    var calendarEntries: [CalendarEntry] = []
    var futureEntries: [CalendarEntry] = []
    
    var dateformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter
    }
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.scrollDirection = .horizontal
        calendarView.showsHorizontalScrollIndicator = false
        
        todayButton.addTarget(self, action: #selector(moveToToday(sender:)), for: .touchUpInside)
        
        reloadUserCalendar()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CalendarVC.showJobCard),
                                               name: NSNotification.Name(rawValue: "calendarEventToJobCard"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CalendarVC.reloadUserCalendar),
                                               name: NSNotification.Name(rawValue: "reloadCalendar"),
                                               object: nil)
        
        self.title = "Finda Calendar"
        
        todayButton.tintColor = UIColor.FindaColours.Blue
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(reloadUserCalendar))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.FindaColours.Blue
        
        
        todayList.delegate = self
        todayList.dataSource = self
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellEvents(cell: cell, cellState: cellState)
    }
    
    @objc func reloadUserCalendar() {
        CalendarEntryManager.getCalendarEntries { (response, result, calendarEntries) in
            
            if response {
                self.calendarEntries = calendarEntries
                self.calendarDataSource.removeAll()
                for entry in calendarEntries {
                    self.calendarDataSource[entry.startDate] = entry
                    if entry.starttime >= Date().timeIntervalSince1970 {
                        self.futureEntries.append(entry)
                    }
                    if entry.startDate != entry.endDate {
                        // fill in extra dates
                        var date = Date(timeIntervalSince1970: entry.starttime + (60*60*24)) // first date
                        let endDate = Date(timeIntervalSince1970: entry.endtime) // last date
                        
                        // Formatter for printing the date, adjust it according to your needs:
                        let fmt = DateFormatter()
                        fmt.dateFormat = "dd-MMM-yyyy"
                        
                        while date <= endDate {
                            self.calendarDataSource[fmt.string(from: date)] = entry
                            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                        }
                        
                    }
                }
                // update the calendar
                self.calendarView.reloadData()
                self.calendarView.scrollToDate(Date())
                if self.futureEntries.count > 0 {
                    self.todayList.reloadData()
                } else {
                    self.todayListLabel.isHidden = false
                    self.todayList.isHidden = true
                }
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
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
    func handleCellEvents(cell: DateCell, cellState: CellState) {
        let dateString = dateformatter.string(from: cellState.date)

        if calendarDataSource[dateString] == nil {
            cell.dotView.isHidden = true
            cell.userDot.isHidden = true
            cell.hasData = true
            // we still need an entry for the day view
            cell.calendarEntry = CalendarEntry(date: cellState.date.timeIntervalSince1970)
        } else {
//            print(self.calendarDataSource[dateString]?.jobid)
            if self.calendarDataSource[dateString]?.jobid == 0 {
//                print("showing user dot")
                cell.userDot.isHidden = false
            } else {
//                print("showing finda dot")
                cell.dotView.isHidden = false
            }
            cell.calendarEntry = self.calendarDataSource[dateString]!
            cell.hasData = true
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let formatter = DateFormatter()
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        
        formatter.dateFormat = "MMMM"
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
        
        var components = DateComponents()
        components.month = -1
        let start = Calendar.current.date(byAdding: components, to: Date())
        components.month = 3
        let end = Calendar.current.date(byAdding: components, to: Date())
        let startDate = start!
        let endDate = end!
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
        if Calendar.current.isDateInToday(date) {
            cell.backgroundColor = UIColor.FindaColours.PaleGreen
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
            cell.addSolidBorder(borderColour: UIColor.FindaColours.Blue)
        } else {
            cell.backgroundColor = UIColor.FindaColours.LighterGreen
            cell.layer.cornerRadius = 0
            cell.layer.masksToBounds = true
            cell.addSolidBorder(borderColour: UIColor.FindaColours.LightGreen)
        }
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        self.performSegue(withIdentifier: "editCalendarSegue", sender: CalendarEntry(date: date.timeIntervalSince1970))
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editCalendarSegue") {
            let vc = segue.destination as? CalendarEntryViewVC
            vc?.calendarEntry = sender as? CalendarEntry
            vc?.dayEntries = self.calendarEntries
        }
        if (segue.identifier == "viewCalendarEntrySegue") {
            let vc = segue.destination as? ViewCalendarEntry
            if let entry = sender as? CalendarEntry {
                vc?.calendarEntry = entry
            }
        }
    }
    
    @objc func showJobCard() {
        // now we have to move VC
        let smc = sideMenuController
        smc?.setContentViewController(with: "MainTabBar")
        (smc?.contentViewController as? UITabBarController)?.selectedIndex = 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calendarEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayTableCell") as! TodayTableCell
        
        if self.calendarEntries.count > 0 {
            cell.todayEntryTitle.text = self.calendarEntries[indexPath.row].title
            cell.todayEntryTitle.textColor = UIColor.FindaColours.Blue
            if self.calendarEntries[indexPath.row].jobid == 0 {
                cell.todayEntryTitle.textColor = UIColor.FindaColours.Pink
            }
            cell.todayEntryBrandname.text = self.calendarEntries[indexPath.row].clientCompany
            
            var dates = self.calendarEntries[indexPath.row].startDate
            if self.calendarEntries[indexPath.row].endDate != self.calendarEntries[indexPath.row].startDate {
                dates = dates + " to " + self.calendarEntries[indexPath.row].endDate
            }
            cell.todayEntryDates.text = dates
            cell.dayEntry = self.calendarEntries[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TodayTableCell
        performSegue(withIdentifier: "viewCalendarEntrySegue", sender: cell.dayEntry)
    }
    
}
