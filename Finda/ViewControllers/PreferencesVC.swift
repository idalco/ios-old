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
        
//        self.tableView?.backgroundColor = UIColor.FindaColors.Purple
//        self.navigationController?.navigationBar.backgroundColor = UIColor.FindaColors.Purple
        
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
                
            }
            
            <<< SwitchRow(){ row in
                row.title = "I receive a job offer"
                row.value = modelManager.jobOffered()
            }
            
            <<< SwitchRow(){ row in
                row.title = "A job I am working on is cancelled"
                row.value = modelManager.jobCancelled()
            }
            
            <<< SwitchRow(){ row in
                row.title = "I receive a payment"
                row.value = modelManager.paymentMade()
            }
            
            
            <<< SwitchRow(){ row in
                row.title = "I receive a notification"
                row.value = modelManager.notifications()
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

