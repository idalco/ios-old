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

class CalendarEntryViewVC: UIViewController {
    
    @IBOutlet weak var backButton: UIImageView!
    
    @IBOutlet weak var entryHolder: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var calendarEntryCollection: UICollectionView!
    
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
        
        self.setUpCollectionView()
        
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
    
    private func setUpCollectionView() {
//        self.noJobsLabel.isHidden = true
        
//        if #available(iOS 10.0, *) {
//            calendarEntryCollection.refreshControl = refreshControl
//        } else {
//            calendarEntryCollection.addSubview(refreshControl)
//        }
//        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        var height: CGFloat = 10.0
        
        if let newLayout = calendarEntryCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            height = newLayout.itemSize.height - 64
        }
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 8, height: height)
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        
        // (note, it's critical to actually set the layout to that!!)
        calendarEntryCollection.collectionViewLayout = layout
    }
    
    /*
     * removes all subviews from the container, and rebuilds from an XIB to show the entries
     */
    func refreshDayView() {
        self.calendarEntryCollection.reloadData()
//        if dayEntries.count != 0 {
//            self.entryHolder.subviews.forEach({ $0.removeFromSuperview() })
//            
//            // inflate and add new views here
//            for entry in dayEntries {
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
//                
//            }
//            self.entryHolder.layoutIfNeeded()
//            
//        } else {
//            // show error label
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
//            label.center = CGPoint(x: 160, y: 285)
//            label.textAlignment = .center
//            label.text = "No events for today"
//            self.entryHolder.addSubview(label)
//        }
    }
    
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension CalendarEntryViewVC: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dayEntries.count > 0 ? 1:0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dayEntries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "showJobDetailsSegue", sender: self.thisTabJobs[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarentrycell", for: indexPath) as! CalendarEntryCardViewCVC
        
//        let entry = self.dayEntries[indexPath.row]
        cell.setRounded(radius: 20)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.FindaColours.Grey.cgColor
        
        cell.cellTitle.text = self.dayEntries[indexPath.row].title
        cell.cellCustomer.text = self.dayEntries[indexPath.row].clientCompany
        cell.cellJobtime.text = Date().displayDate(timeInterval: Int(self.dayEntries[indexPath.row].starttime), format: "h:mm a")
        cell.cellLocation.text = self.dayEntries[indexPath.row].location
        cell.cellJobstatus.text = self.dayEntries[indexPath.row].jobtypeDescription
        
        cell.cellJobstatus.textColor = UIColor.FindaColours.Blue
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
}
