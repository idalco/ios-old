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
 
    @IBOutlet weak var calendarView: JTACMonthView!
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
        
        self.title = "FINDA CALENDAR"
        
        todayButton.tintColor = UIColor.FindaColours.Black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(reloadUserCalendar))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.FindaColours.Black
        
        
        todayList.delegate = self
        todayList.dataSource = self
        
        todayList.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue|UIView.AutoresizingMask.flexibleWidth.rawValue)

        todayList.isEditing = false
        
        updateNotificationCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        todayList.reloadData()
    }
    
    func configureCell(view: JTACDayCell?, cellState: CellState) {
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
                self.futureEntries.removeAll()
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
//                    self.todayListLabel.sizeToFit()
//                    self.todayListLabel.setNeedsLayout()
                }
            } else {
                // show error
            }
        }
        
        
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.FindaColours.Burgundy
        } else {
            cell.dateLabel.textColor = UIColor.FindaColours.Grey
        }
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.layer.cornerRadius =  2
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
    func handleCellEvents(cell: DateCell, cellState: CellState) {
        let dateString = dateformatter.string(from: cellState.date)

        cell.dotView.isHidden = true
        cell.userDot.isHidden = true
        cell.hasData = false
        // we still need an entry for the day view
        cell.calendarEntry = CalendarEntry(date: cellState.date.timeIntervalSince1970)
        
        if calendarDataSource[dateString] == nil {
            cell.hasData = true
        } else {
            if self.calendarDataSource[dateString]?.jobid == 0 {
                cell.userDot.isHidden = false
            } else {
                cell.dotView.isHidden = false
            }
            cell.calendarEntry = self.calendarDataSource[dateString]!
            cell.hasData = true
        }
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let formatter = DateFormatter()
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        
        formatter.dateFormat = "MMMM"
        header.monthTitle.text = formatter.string(from: range.start)
        
        formatter.dateFormat = "yyyy"
        header.yearTitle.text = formatter.string(from: range.start)
        
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
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
    
    private func updateNotificationCount() {
        NotificationManager.countNotifications(notificationType: .new) { (response, result) in
            if response {
                let count = result["userdata"].numberValue
                if count != 0 {
                    self.tabBarController?.tabBar.items?[2].badgeValue = result["userdata"].stringValue
                } else {
                    self.tabBarController?.tabBar.items?[2].badgeValue = nil
                }
            }
        }
    }
}

extension CalendarVC: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
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

extension CalendarVC: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        cell.backgroundColor = UIColor.FindaColours.White
        cell.layer.cornerRadius = 0
        cell.layer.masksToBounds = true
        cell.removeBorder()
        if Calendar.current.isDateInToday(date) {
            cell.layer.cornerRadius = 2
            cell.addSolidBorder(borderColour: UIColor.FindaColours.Burgundy, cornerRadius: 2, width: 4)
        } else {
            cell.addSolidBorder(borderColour: UIColor.FindaColours.LightGrey)
        }
        configureCell(view: cell, cellState: cellState)
    }
    
    // new delegate
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        
        configureCell(view: cell, cellState: cellState)
        self.performSegue(withIdentifier: "editCalendarSegue", sender: CalendarEntry(date: date.timeIntervalSince1970))
    }

    // new delegate
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
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
        return self.futureEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayTableCell") as! TodayTableCell
        
        if self.futureEntries.count > 0 {
            cell.todayEntryTitle.text = self.futureEntries[indexPath.row].title
            cell.todayEntryTitle.textColor = UIColor.FindaColours.Black
            cell.todayEntryBrandname.text = self.futureEntries[indexPath.row].clientCompany            
            cell.dayEntry = self.futureEntries[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TodayTableCell
        performSegue(withIdentifier: "viewCalendarEntrySegue", sender: cell.dayEntry)
    }
    
}

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
