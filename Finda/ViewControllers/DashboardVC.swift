//
//  DashboardVC.swift
//  
//
//  Created by Peter Lloyd on 26/07/2018.
//

import UIKit
import FoldingCell

class DashboardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var allJobs: [Job] = []
    
    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 400
        
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        self.tableView.refreshControl?.beginRefreshing()
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadJobs()
        self.updateNotificationCount()
    }
    
    private func updateNotificationCount(){
        NotificationManager.countNotifications(notificationType: .new) { (response, result) in
            if response {
                self.tabBarController?.tabBar.items?[1].badgeValue = result["userdata"].string
            }
        }
    }
    
    private func loadJobs(){
        JobsManager.getJobs(jobType: .all) { (response, result) in
            self.tableView.refreshControl?.endRefreshing()
            if(response) {
                self.allJobs.removeAll()
                let jobs = result["userdata"].dictionaryValue
                
                for job in jobs {
                    self.allJobs.append(Job(data: job.value))
                }
                self.reloadData()
            }
        }

    }
    @IBAction func showMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    private func reloadData(){
        self.cellHeights = Array(repeating: Const.closeCellHeight, count: self.allJobs.count)
        self.tableView.reloadData()
    }
    
    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: self.allJobs.count)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension

        if #available(iOS 10.0, *) {
            let refresh =  UIRefreshControl()
            refresh.tintColor = UIColor.white
            self.tableView.refreshControl = refresh
            
            
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    @objc func refreshHandler() {
        self.loadJobs()
//        let deadlineTime = DispatchTime.now() + .seconds(1)
//        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
//            if #available(iOS 10.0, *) {
//                self?.tableView.refreshControl?.endRefreshing()
//            }
//            self?.tableView.reloadData()
//        })
    }
}

// MARK: - TableView

extension DashboardVC {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return self.allJobs.count
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DashboardCell = cell else {
            return
        }
        
        let job = allJobs[indexPath.row]
        
        cell.backgroundColor = .clear
        
        cell.openDescriptionLabel.text = job.description
        cell.openCompanyLabel.text = job.companyName
        cell.openJobTypeLabel.text = job.jobtype
        cell.openLocationLabel.text = job.location
        cell.openDateLabel.text = Date().displayDate(timeInterval: job.startdate, format:  "MMM dd, yyyy")
        cell.openLengthLabel.text = JobsManager.length(length: job.timeUnits, unit: job.unitsType)
        cell.openInformationLabel.text = job.name

        cell.closedDescriptionLabel.text = job.description
        cell.closedCompanyLabel.text = job.companyName
        cell.closedJobTypeLabel.text = job.jobtype
        cell.closedLocationLabel.text = job.location
        cell.closedDateLabel.text = Date().displayDate(timeInterval: job.startdate, format:  "MMM dd, yyyy")
        cell.closedLengthLabel.text =  JobsManager.length(length: job.timeUnits, unit: job.unitsType)
        
        
        
        
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil) 
    }
}

