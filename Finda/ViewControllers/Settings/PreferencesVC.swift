//
//  PreferencesVC.swift
//  Finda
//
//  Created by Peter Lloyd on 28/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//


import UIKit
import Eureka

class PreferencesVC: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.backgroundColor = UIColor.white
        self.updateRows()
        
        let modelManager = ModelManager()
        
        SwitchRow.defaultCellSetup = { cell, row in
            cell.textLabel?.font = UIFont(name: "Gotham-Light", size: 16)
            cell.switchControl?.onTintColor = UIColor.FindaColours.Blue
        }
        
        form +++ Section(){ section in
            var header = HeaderFooterView<UIView>(.class)
            header.height = {100}
            header.onSetupView = { view, _ in
                view.backgroundColor = UIColor.FindaColours.White
                let title = UILabel(frame: CGRect(x:10,y: 5, width:self.view.frame.width, height:80))
                
                title.text = "Preferences"
                title.font = UIFont(name: "Gotham-Medium", size: 17)
                view.addSubview(title)
                
                let description = UILabel(frame: CGRect(x:10,y: 70, width:self.view.frame.width, height:20))
                description.numberOfLines = 0
                description.text = "Set your email contact preferences."
                description.font = UIFont(name: "Gotham-Light", size: 13)
                view.addSubview(description)
                
            }
            section.header = header
            }
            
            <<< SwitchRow(){ row in
                row.title = "A friend users my referrer code"
                row.value = modelManager.friendRegisters()
                row.tag = "friendRegisters"
                
                
            }
            
            <<< SwitchRow(){ row in
                row.title = "I receive a job offer"
                row.value = modelManager.jobOffered()
                row.tag = "jobOffered"
            }
            
            <<< SwitchRow(){ row in
                row.title = "A job I am working on is cancelled"
                row.value = modelManager.jobCancelled()
                row.tag = "jobCancelled"
            }
            
            <<< SwitchRow(){ row in
                row.title = "A job I am working on is changed"
                row.value = modelManager.jobChanged()
                row.tag = "jobChanged"
            }
            
            <<< SwitchRow(){ row in
                row.title = "I receive a payment"
                row.value = modelManager.paymentMade()
                row.tag = "paymentMade"
            }
            
            
            <<< SwitchRow(){ row in
                row.title = "I receive an update"
                row.value = modelManager.notifications()
                row.tag = "notifications"
            }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.save()
    }
    
    private func updateRows(){
        LoginManager.getDetails { (response, result) in
            if response {
                let model = ModelManager()
        
                self.updateCell(tag: "friendRegisters", data: model.friendRegisters())
                self.updateCell(tag: "jobOffered", data: model.jobOffered())
                self.updateCell(tag: "jobCancelled", data: model.jobCancelled())
                self.updateCell(tag: "jobChanged", data: model.jobChanged())
                self.updateCell(tag: "paymentMade", data: model.paymentMade())
                self.updateCell(tag: "notifications", data: model.notifications())
             
            }
            
        }
    }
    
    private func updateCell(tag: String, data: Any){
        guard let row: BaseRow = form.rowBy(tag: tag) else { return }
        row.baseValue = data
        row.updateCell()
    }
    
    func save() {

        guard let friend_registers: Bool = form.values()["friendRegisters"] as? Bool else { return }
        guard let friend_registersString: String = friend_registers ? "on" : "" else { return }
        
        guard let job_offered: Bool = form.values()["jobOffered"] as? Bool else { return }
        guard let job_offeredString: String = job_offered ? "on" : "" else { return }
        
        guard let job_cancelled: Bool = form.values()["jobCancelled"] as? Bool else { return }
        guard let job_cancelledString: String = job_cancelled ? "on" : "" else { return }
        
        guard let job_changed: Bool = form.values()["jobChanged"] as? Bool else { return }
        guard let job_changedString: String = job_changed ? "on" : "" else { return }
        
        
        guard let payment_made: Bool = form.values()["paymentMade"] as? Bool else { return }
        guard let payment_madeString: String = payment_made ? "on" : "" else { return }
        
        guard let notifications: Bool = form.values()["notifications"] as? Bool else { return }
        guard let notificationsString: String = notifications ? "on" : "" else { return }
        
        
        FindaAPISession(target: .updatePreferences(friend_registers: friend_registersString, job_offered: job_offeredString, job_cancelled: job_cancelledString, job_changed: job_changedString, payment_made: payment_madeString, notifications: notificationsString)) { (response, result) in
            if response {
                self.updateRows()
            }
        }
        
    }
    
    
    func validateRow(tag: String){
        let row: BaseRow? = form.rowBy(tag: tag)
        _ = row?.validate()
    }
    
    func placeholderRed(row: TextRow){
        row.add(rule: RuleRequired())
        row.validationOptions = .validatesOnChange
        row.cellUpdate { (cell, row) in
            if !row.isValid {
                cell.textField.attributedPlaceholder = NSAttributedString(string: row.placeholder ?? "",
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.FindaColours.FindaRed])
            }
        }
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

