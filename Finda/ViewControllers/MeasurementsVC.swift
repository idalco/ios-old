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
        
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textField.font = UIFont(name: "Gotham-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Gotham-Light", size: 16)
        }
        
        
        
        var section = Section(){ section in
            var header = HeaderFooterView<UIView>(.class)
            header.height = {70}
            header.onSetupView = { view, _ in
                view.backgroundColor = UIColor.FindaColors.White
                let title = UILabel(frame: CGRect(x:10,y: 5, width:self.view.frame.width, height:40))
                
                title.text = "Measurements"
                title.font = UIFont(name: "Gotham-Medium", size: 17)
                view.addSubview(title)
                
                let description = UILabel(frame: CGRect(x:10,y: 40, width:self.view.frame.width, height:30))
                description.numberOfLines = 0
                description.text = "Please enter your measurements in centimeters."
                description.font = UIFont(name: "Gotham-Light", size: 13)
                view.addSubview(description)
                
            }
            section.header = header
            }
            
            <<< IntRow(){ row in
                row.title = "Height"
                let data = CoreDataManager.getInt(dataName: "height", entity: "Profile")
                if data != -1 {
                    row.value = data
                }
                
            }
            
            
            <<< IntRow(){ row in
                row.title = "Bust"
                let data = CoreDataManager.getInt(dataName: "bust", entity: "Profile")
                if data != -1 {
                    row.value = data
                }
            }
            
            <<< IntRow(){ row in
                row.title = "Waist"
                let data = CoreDataManager.getInt(dataName: "waist", entity: "Profile")
                if data != -1 {
                    row.value = data
                }
            }
            
            <<< IntRow(){ row in
                row.title = "Hips"
                let data = CoreDataManager.getInt(dataName: "hips", entity: "Profile")
                if data != -1 {
                    row.value = data
                }
            }
            <<< IntRow(){ row in
                row.title = "Shoe Size"
                let data = CoreDataManager.getInt(dataName: "shoeSize", entity: "Profile")
                if data != -1 {
                    row.value = data
                }
            }
            <<< IntRow(){ row in
                row.title = "Dress Size"
                let data = CoreDataManager.getInt(dataName: "dressSize", entity: "Profile")
                if data != -1 {
                    row.value = data
                }
        }
        
        //            <<< PickerInlineRow<String>() { row in
        //                row.title = rowTitle
        //                let coreData = CoreDataManager.getInt(dataName: "willingColour", entity: "Profile")
        //                if row.value == nil && coreData != -1 {
        //                    row.value = dictionary[coreData] ?? ""
        //                }
        //                row.options = Array(dictionary.values)
        //            }
        
        form +++ section
        
        PickerDelegate.addPickerData(term: .HairColour, rowTitle: "Hair Colour", coreDataName: "hairColour", entity: "Profile") { (response, result) in
            if response {
                section.insert(result, at: section.count)
            }
        }
        
        PickerDelegate.addPickerData(term: .HairType, rowTitle: "Hair Type", coreDataName: "hairType", entity: "Profile") { (response, result) in
            if response {
                section.insert(result, at: section.count)
            }
        }
        
        PickerDelegate.addPickerData(term: .HairLength, rowTitle: "Hair Length", coreDataName: "hairLength", entity: "Profile") { (response, result) in
            if response {
                section.insert(result, at: section.count)
            }
        }
        
        PickerDelegate.addPickerData(term: .EyeColour, rowTitle: "Eye Colour", coreDataName: "eyeColour", entity: "Profile") { (response, result) in
            if response {
                section.insert(result, at: section.count)
            }
        }
        
        PickerDelegate.addPickerData(rowTitle: "Willing to colour?", coreDataName: "willingColour", entity: "Profile") { (response, result) in
            if response {
                section.insert(result, at: section.count)
            }
        }
        
        PickerDelegate.addPickerData(rowTitle: "Willing to cut?", coreDataName: "willingCut", entity: "Profile") { (response, result) in
            if response {
                section.insert(result, at: section.count)
            }
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
