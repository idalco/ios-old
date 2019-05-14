//
//  InvoiceVC.swift
//  Finda
//
//  Created by Peter Lloyd on 01/09/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import SafariServices

class InvoiceVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var invoices: [Invoice] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadInvoices()
    }
    
    func loadInvoices(){
        InvoiceManager.getInvoice { (response, result, invoices) in
            self.tableView.refreshControl?.endRefreshing()
            if response {
                self.invoices = invoices
                self.tableView.reloadData()
            }
        }
    }
    
    private func setup() {
        if #available(iOS 10.0, *) {
            let refresh =  UIRefreshControl()
            refresh.tintColor = UIColor.black
            self.tableView.refreshControl = refresh
            
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    @objc func refreshHandler() {
        self.loadInvoices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }

}

extension InvoiceVC: UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InvoiceTVC
        let invoice = self.invoices[indexPath.row]
        
        let description = invoice.description.components(separatedBy: ":")
        
        cell.amount.text = "£\(invoice.value)"
        cell.projectName.text = description.first
        if invoice.date_paid != 0 || invoice.date_paid != 0 {
            cell.paidOn.text = Date().displayDate(timeInterval: invoice.date_paid, format: "MMM dd, yyyy")
        } else {
            cell.paidOn.text = ""
        }
        
        cell.invoiceNumber.text = description.last
        
        cell.paid.text = invoice.transaction_id == 0 ? "UNPAID" : "PAID"
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.invoices.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.invoices.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let url = URL(string: "https://finda.co/generate/invoice/\(invoices[indexPath.row].id)") {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        }
    }
}
