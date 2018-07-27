//
//  MeasurementsVC.swift
//  Finda
//
//  Created by Peter Lloyd on 27/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import Eureka

class MeasurementsVC: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.backgroundColor = UIColor.FindaColors.Purple
        self.navigationController?.navigationBar.backgroundColor = UIColor.FindaColors.Purple
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
            header.height = {70}
            header.onSetupView = { view, _ in
                view.backgroundColor = UIColor.FindaColors.White
                let title = UILabel(frame: CGRect(x:5,y: 5, width:self.view.frame.width, height:40))
                
                title.text = "Measurements"
                title.font = UIFont(name: "Gotham-Medium", size: 17)
                view.addSubview(title)
                
                let description = UILabel(frame: CGRect(x:5,y: 40, width:self.view.frame.width, height:30))
                description.numberOfLines = 0
                description.text = "Please enter your measurements in centimeters."
                description.font = UIFont(name: "Gotham-Light", size: 13)
                view.addSubview(description)
                
            }
            section.header = header
            }
            
            <<< IntRow(){ row in
                row.title = "Height"
                row.placeholder = ""
                //placeholderRed(row: row)
            }
            
            
            <<< IntRow(){ row in
                row.title = "Bust"
                row.placeholder = ""
                //placeholderRed(row: row)
            }

            <<< IntRow(){ row in
                row.title = "Waist"
                row.placeholder = ""
                //placeholderRed(row: row)
            }
            
            <<< IntRow(){ row in
                row.title = "Hips"
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
