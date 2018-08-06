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
        
//        self.tableView?.backgroundColor = UIColor.FindaColors.Purple
//        self.navigationController?.navigationBar.backgroundColor = UIColor.FindaColors.Purple
        
        let modelManager = ModelManager()
        
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
                
                let description = UILabel(frame: CGRect(x:10,y: 40, width:self.view.frame.width, height:20))
                description.numberOfLines = 0
                description.text = "Please enter your measurements in centimeters."
                description.font = UIFont(name: "Gotham-Light", size: 13)
                view.addSubview(description)
                
            }
            section.header = header
            }
            
            <<< IntRow(){ row in
                row.title = "Height"
                let data = modelManager.height()
                if data != -1 {
                    row.value = data
                }
                
            }
            
            
            <<< IntRow(){ row in
                row.title = "Bust"
                let data = modelManager.bust()
                if data != -1 {
                    row.value = data
                }
            }
            
            <<< IntRow(){ row in
                row.title = "Waist"
                let data = modelManager.waist()
                if data != -1 {
                    row.value = data
                }
            }
            
            <<< IntRow(){ row in
                row.title = "Hips"
                let data = modelManager.hips()
                if data != -1 {
                    row.value = data
                }
            }
            <<< IntRow(){ row in
                row.title = "Shoe Size"
                let data = modelManager.shoeSize()
                if data != -1 {
                    row.value = data
                }
            }
            <<< IntRow(){ row in
                row.title = "Dress Size"
                let data = modelManager.dressSize()
                if data != -1 {
                    row.value = data
                }
        }
        
        form +++ section
        
        PickerDelegate.addPickerData(term: .HairColour, rowTitle: "Hair Colour", coreData: modelManager.hairColour()) { (response, result) in
            if response {
                section.insert(result, at: section.count)
            }
        }
        
        PickerDelegate.addPickerData(term: .HairType, rowTitle: "Hair Type", coreData: modelManager.hairType()) { (response, result) in
            if response {
                section.insert(result, at: section.count)
            }
        }
        
        PickerDelegate.addPickerData(term: .HairLength, rowTitle: "Hair Length", coreData: modelManager.hairLength()) { (response, result) in
            if response {
                section.insert(result, at: section.count)
            }
        }
        
        PickerDelegate.addPickerData(term: .EyeColour, rowTitle: "Eye Colour", coreData: modelManager.eyeColour()) { (response, result) in
            if response {
                section.insert(result, at: section.count)
            }
        }
        
        PickerDelegate.addPickerData(rowTitle: "Willing to colour?", coreData: modelManager.willingColour()) { (response, result) in
            if response {
                section.insert(result, at: section.count)
            }
        }
        
        PickerDelegate.addPickerData(rowTitle: "Willing to cut?", coreData: modelManager.willingCut()) { (response, result) in
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
    
    @IBAction func save(_ sender: Any) {
        
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
