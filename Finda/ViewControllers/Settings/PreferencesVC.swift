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

        
        let modelManager = ModelManager()
        
        SwitchRow.defaultCellSetup = { cell, row in
            cell.textLabel?.font = UIFont(name: "Gotham-Light", size: 16)
            
        }
        
        form +++ Section(){ section in
            var header = HeaderFooterView<UIView>(.class)
            header.height = {70}
            header.onSetupView = { view, _ in
                view.backgroundColor = UIColor.FindaColors.White
                let title = UILabel(frame: CGRect(x:10,y: 5, width:self.view.frame.width, height:40))
                
                title.text = "Preferences"
                title.font = UIFont(name: "Gotham-Medium", size: 17)
                view.addSubview(title)
                
                let description = UILabel(frame: CGRect(x:10,y: 40, width:self.view.frame.width, height:20))
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
                row.title = "I receive a notification"
                row.value = modelManager.notifications()
                row.tag = "notifications"
            }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: Any) {

        guard let friend_registers: Bool = form.values()["friendRegisters"] as? Bool else { return }
        guard let friend_registersInt: Int = friend_registers ? 1 : 0 else { return }
        
        guard let job_offered: Bool = form.values()["jobOffered"] as? Bool else { return }
        guard let job_offeredInt: Int = job_offered ? 1 : 0 else { return }
        
        guard let job_cancelled: Bool = form.values()["jobCancelled"] as? Bool else { return }
        guard let job_cancelledInt: Int = job_cancelled ? 1 : 0 else { return }
        
        guard let job_changed: Bool = form.values()["jobChanged"] as? Bool else { return }
        guard let job_changedInt: Int = job_changed ? 1 : 0 else { return }
        
        
        guard let payment_made: Bool = form.values()["paymentMade"] as? Bool else { return }
        guard let payment_madeInt: Int = payment_made ? 1 : 0 else { return }
        
        guard let notifications: Bool = form.values()["notifications"] as? Bool else { return }
        guard let notificationsInt: Int = notifications ? 1 : 0 else { return }
        
        
        FindaAPISession(target: .updatePreferences(friend_registers: friend_registersInt, job_offered: job_offeredInt, job_cancelled: job_cancelledInt, job_changed: job_changedInt, payment_made: payment_madeInt, notifications: notificationsInt)) { (response, result) in
            if response {
                
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
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.FindaColors.FindaRed])
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

