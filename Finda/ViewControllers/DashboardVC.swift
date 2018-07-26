//
//  DashboardVC.swift
//  Finda
//
//  Created by Peter Lloyd on 24/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import Eureka

class DashboardVC: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.FindaColors.Yellow
        self.tableView?.backgroundColor = UIColor.white
        _ = self.load()
        TextRow.defaultCellSetup = { cell, row in
//            // Changes separatorInset to yellow
//            row.cell.separatorInset = UIEdgeInsets(top: 0, left: 2000, bottom: 0, right: 0)
//            row.baseCell.setBottomBorder(colour: UIColor.FindaColors.Yellow)
            
            cell.textField.attributedPlaceholder = NSAttributedString(string: row.placeholder ?? "",
                                                                      attributes: [NSAttributedStringKey.foregroundColor: UIColor.FindaColors.Grey])
            
            cell.textField.font = UIFont(name: "Gotham-Light", size: 50)
        }

        
        DateRow.defaultCellSetup = { cell, row in
            // Changes separatorInset to yellow
//            row.cell.separatorInset = UIEdgeInsets(top: 0, left: 2000, bottom: 0, right: 0)
            row.baseCell.setBottomBorder(colour: UIColor.FindaColors.Yellow)
        }

        form +++ Section(){ section in
            var header = HeaderFooterView<UIView>(.class)
            header.height = {40}
            header.onSetupView = { view, _ in
                view.backgroundColor = UIColor.FindaColors.White
                let label = UILabel(frame: CGRect(x:5,y: 5, width:300, height:40))
                
                label.text = "Personal Details"
                label.font = UIFont(name: "Gotham-Medium", size: 19)
                view.addSubview(label)
            }
            section.header = header
            }   <<< TextRow(){ row in
                row.title = "First name"
                row.placeholder = ""
                //placeholderRed(row: row)
            }
            
            <<< TextRow(){ row in
                row.title = "Last name"
                row.placeholder = ""
                //placeholderRed(row: row)
            }
            
            <<< DateInlineRow(){ row in
                
                row.title = "Date of Birth"
                row.value = Date(timeIntervalSinceReferenceDate: 0)
              
            }
            <<< PickerInlineRow<String>() { row in
                row.title = "Nationality"
            
                row.options = ["One","Two","Three"]
                row.value = "Two"
            }
            
            <<< PickerInlineRow<String>() { row in
                row.title = "Country of residence"
                
                row.options = ["One","Two","Three"]
                row.value = "Two"
            }
            
        
            <<< TextRow(){ row in
                row.title = "VAT Number"
                row.placeholder = "(optional)"
                //placeholderRed(row: row)
            }
            
            <<< EmailRow(){ row in
                row.title = "Email address"
                row.placeholder = ""
                //placeholderRed(row: row)
            }
        
            <<< TextRow(){ row in
                row.title = "Referral Code"
                row.placeholder = ""
                //placeholderRed(row: row)
            }
            <<< PickerInlineRow<String>() { row in
                row.title = "Gender"
                
                row.options = ["Male", "Female"]
                row.value = "Male"
            }
            <<< PickerInlineRow<String>() { row in
                row.title = "Ethnicity"
                
                row.options = ["One","Two","Three"]
                row.value = "Two"
            }
            <<< TextRow(){ row in
                row.title = "Instagram Username"
                row.placeholder = ""
                //placeholderRed(row: row)
            }
            
            <<< IntRow(){ row in
                row.title = "Followers"
                row.disabled = true
                row.placeholder = ""
                //placeholderRed(row: row)
            }
            <<< IntRow(){ row in
                row.title = "Minimum Hourly Rate"
                row.placeholder = ""
                //placeholderRed(row: row)
            }
            <<< IntRow(){ row in
                row.title = "Minimum Daily Rate"
                row.placeholder = ""
                //placeholderRed(row: row)
            }
        // Do any additional setup after loading the view.
    }

    func load() -> [String: Int]{
        FindaAPISession(target: .termData(term: TermData.Ethnicity)) { (response, result) in
            if(response){
                print(result)
                
            }
            print(response)

        }
        return [:]
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
