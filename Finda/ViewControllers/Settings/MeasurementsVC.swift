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
    
    
    var hairTypeDictionary: [Int: String] = [:]
    var hairColourDictionary: [Int: String] = [:]
    var hairLengthDictionary: [Int: String] = [:]
    var eyeColourDictionary: [Int: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateRows()
//        self.tableView?.backgroundColor = UIColor.FindaColors.Purple
//        self.navigationController?.navigationBar.backgroundColor = UIColor.FindaColors.Purple
        
        let modelManager = ModelManager()
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textField.font = UIFont(name: "Gotham-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Gotham-Light", size: 16)
        }
        
        PickerInputRow<String>.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = UIFont(name: "Gotham-Light", size: 16)
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
                row.tag = "Height".lowercased()
                let data = modelManager.height()
                if data != -1 {
                    row.value = data
                }
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                        
                    }
                
            }
            
            
            <<< IntRow(){ row in
                row.title = "Bust"
                row.tag = "Bust".lowercased()
                let data = modelManager.bust()
                if data != -1 {
                    row.value = data
                }
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                        
                    }
            }
            
            <<< IntRow(){ row in
                row.title = "Waist"
                row.tag = "Waist".lowercased()
                let data = modelManager.waist()
                if data != -1 {
                    row.value = data
                }
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                        
                    }
            }
            
            <<< IntRow(){ row in
                row.title = "Hips"
                row.tag = "Hips".lowercased()
                let data = modelManager.hips()
                if data != -1 {
                    row.value = data
                }
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                        
                    }
            }
            <<< IntRow(){ row in
                row.title = "Shoe Size"
                row.tag = "Shoe Size".lowercased()
                let data = modelManager.shoeSize()
                if data != -1 {
                    row.value = data
                }
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                        
                    }
            }
            <<< IntRow(){ row in
                row.title = "Dress Size"
                row.tag = "Dress Size".lowercased()
                let data = modelManager.dressSize()
                if data != -1 {
                    row.value = data
                }
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                        
                    }
        }
        
        form +++ section
        
        
        PickerDelegate.addPickerData(term: .HairColour, rowTitle: "Hair Colour", coreData: modelManager.hairColour()) { (response, result, dictionary) in
            if response {
                self.hairColourDictionary = dictionary
                section.insert(result, at: section.count)
                section.reload()
            }
        }
        
        PickerDelegate.addPickerData(term: .HairType, rowTitle: "Hair Type", coreData: modelManager.hairType()) { (response, result, dictionary) in
            if response {
                self.hairTypeDictionary = dictionary
                section.insert(result, at: section.count)
                section.reload()

            }
        }
        
        PickerDelegate.addPickerData(term: .HairLength, rowTitle: "Hair Length", coreData: modelManager.hairLength()) { (response, result, dictionary) in
            if response {
                self.hairLengthDictionary = dictionary
                section.insert(result, at: section.count)
                section.reload()

            }
        }
        
        PickerDelegate.addPickerData(term: .EyeColour, rowTitle: "Eye Colour", coreData: modelManager.eyeColour()) { (response, result, dictionary) in
            if response {
                self.eyeColourDictionary = dictionary
                section.insert(result, at: section.count)
                section.reload()

            }
        }
        
        PickerDelegate.addPickerData(rowTitle: "Willing to colour?", coreData: modelManager.willingColour()) { (response, result) in
            if response {
                section.insert(result, at: section.count)
                section.reload()

            }
        }
        
        PickerDelegate.addPickerData(rowTitle: "Willing to cut?", coreData: modelManager.willingCut()) { (response, result) in
            if response {
                section.insert(result, at: section.count)
                section.reload()

            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.save()
    }
    
    
    private func updateRows(){
        LoginManager.getDetails { (response, result) in
            if response {
                let model = ModelManager()
                self.updateCell(tag: "height", data: model.height())
                self.updateCell(tag: "bust", data: model.bust())
        
                self.updateCell(tag: "waist", data: model.waist())
                self.updateCell(tag: "hips", data: model.hips())
                self.updateCell(tag: "shoe size", data: model.shoeSize())
                self.updateCell(tag: "dress size", data: model.dressSize())
                
                if let hairColour: String = self.hairColourDictionary[model.hairColour()] {
                    self.updateCell(tag: "hair colour", data: hairColour)
                }
                
                if let hairType: String = self.hairTypeDictionary[model.hairType()] {
                    self.updateCell(tag: "hair type", data: hairType)
                }
                
                if let hairLength: String = self.hairLengthDictionary[model.hairLength()] {
                    self.updateCell(tag: "hair length", data: hairLength)
                }
                
                if let eyeColour: String = self.eyeColourDictionary[model.eyeColour()] {
                    self.updateCell(tag: "eye colour", data: eyeColour)
                }
                
                
                if let eyeColour: String = self.eyeColourDictionary[model.eyeColour()] {
                    self.updateCell(tag: "eye colour", data: eyeColour)
                }
                

                if let willingColour: String = BooleanDictionary[model.willingColour()] {
                    self.updateCell(tag: "willing to colour?", data: willingColour)
                }
                
                if let willingCut: String = BooleanDictionary[model.willingCut()] {
                    self.updateCell(tag: "willing to cut?", data: willingCut)
                }
            }
            
        }
    }
    
    private func updateCell(tag: String, data: Any){
        guard let row: BaseRow = form.rowBy(tag: tag) else { return }
        row.baseValue = data
        row.updateCell()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save() {
        
        guard let heightRow: BaseRow = form.rowBy(tag: "height"), let height: Int = form.values()["height"] as? Int else {
            self.validateRow(tag: "height")
            return
        }
        guard let bustRow: BaseRow = form.rowBy(tag: "bust"), let bust: Int = form.values()["bust"] as? Int else {
            self.validateRow(tag: "bust")
            return
        }
        
        guard let waistRow: BaseRow = form.rowBy(tag: "waist"), let waist: Int = form.values()["waist"] as? Int else {
            self.validateRow(tag: "waist")
            return
        }
        
        guard let hipsRow: BaseRow = form.rowBy(tag: "hips"), let hips: Int = form.values()["hips"] as? Int else {
            self.validateRow(tag: "hips")
            return
        }
        
        guard let shoeSizeRow: BaseRow = form.rowBy(tag: "shoe size"), let shoeSize: Int = form.values()["shoe size"] as? Int else {
            self.validateRow(tag: "shoe size")
            return
        }
        
        guard let dressSizeRow: BaseRow = form.rowBy(tag: "dress size"), let dressSize: Int = form.values()["dress size"] as? Int else {
            self.validateRow(tag: "dress size")
            return
        }
        
        guard let hairColourRow: BaseRow = form.rowBy(tag: "hair colour"), let hairColour: String = form.values()["hair colour"] as? String else {
            self.validateRow(tag: "hair colour")
            return
        }
        
        guard let hairTypeRow: BaseRow = form.rowBy(tag: "hair type"), let hairType: String = form.values()["hair type"] as? String else {
            self.validateRow(tag: "hair type")
            return
        }

        
        guard let hairLengthRow: BaseRow = form.rowBy(tag: "hair length"), let hairLength: String = form.values()["hair length"] as? String else {
            self.validateRow(tag: "hair length")
            return
        }
        
        guard let eyeColourRow: BaseRow = form.rowBy(tag: "eye colour"), let eyeColour: String = form.values()["eye colour"] as? String else {
            self.validateRow(tag: "eye colour")
            return
        }
        
        guard let willingToColourRow: BaseRow = form.rowBy(tag: "willing to colour?"), let willingToColour: String = form.values()["willing to colour?"] as? String else {
            self.validateRow(tag: "willing to colour?")
            return
        }
        
        guard let willingToCutRow: BaseRow = form.rowBy(tag: "willing to cut?"), let willingToCut: String = form.values()["willing to cut?"] as? String else {
            self.validateRow(tag: "willing to cut?")
            return
        }
        
        
        guard let hairTypeId = hairTypeDictionary.allKeysForValue(val: hairType).first else {
            return
        }
        
        guard let hairColourId = hairColourDictionary.allKeysForValue(val: hairColour).first else {
            return
        }
        
        guard let eyeColourId = eyeColourDictionary.allKeysForValue(val: eyeColour).first else {
            return
        }
        
        guard let hairLengthId = hairLengthDictionary.allKeysForValue(val: hairLength).first else {
            return
        }
        
        
        let willingToColourId: Int = willingToColour.lowercased() == "yes" ? 1 : 0
        let willingToCutId: Int = willingToCut.lowercased() == "yes" ? 1 : 0
        
        
        
        if(heightRow.isValid && bustRow.isValid && waistRow.isValid && hipsRow.isValid && shoeSizeRow.isValid && dressSizeRow.isValid && hairColourRow.isValid && hairLengthRow.isValid && hairTypeRow.isValid && eyeColourRow.isValid && willingToColourRow.isValid && willingToCutRow.isValid){
            FindaAPISession(target: .updateMeasurements(height: height, bust: bust, waist: waist, hips: hips, shoeSize: shoeSize, dressSize: dressSize, hairColour: hairColourId, hairLength: hairLengthId, hairType: hairTypeId, eyeColour: eyeColourId, willingToColour: willingToColourId, willingToCut: willingToCutId)) { (response, result) in
                if response {
                    self.updateRows()
                }
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
