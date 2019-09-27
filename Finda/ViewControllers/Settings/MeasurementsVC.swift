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
        self.tableView?.backgroundColor = UIColor.white
        self.updateRows()
//        self.tableView?.backgroundColor = UIColor.FindaColors.Purple
//        self.navigationController?.navigationBar.backgroundColor = UIColor.FindaColors.Purple
        
        let modelManager = ModelManager()
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textField.font = UIFont(name: "Montserrat-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
        }
        
        PickerInputRow<String>.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
        }
        
        SwitchRow.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
        }
        
        var section = Section()
        
        if modelManager.gender() == "female" {
            section = Section() { section in
                var header = HeaderFooterView<UIView>(.class)
                header.height = {100}
                header.onSetupView = { view, _ in
                    view.backgroundColor = UIColor.FindaColours.White
                    let title = UILabel(frame: CGRect(x:10,y: 5, width:self.view.frame.width, height:80))
                    
                    title.text = "Measurements"
                    title.font = UIFont(name: "Montserrat-Medium", size: 17)
                    view.addSubview(title)
                    
                    let description = UILabel(frame: CGRect(x:10,y: 70, width:self.view.frame.width, height:20))
                    description.numberOfLines = 0
                    description.text = "Please enter your measurements in centimeters."
                    description.font = UIFont(name: "Montserrat-Light", size: 13)
                    view.addSubview(description)
                    
                }
                section.header = header
            }
                
            <<< IntRow() { row in
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
                
            <<< IntRow() { row in
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
                
            <<< IntRow() { row in
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
                
            <<< IntRow() { row in
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
            <<< PickerInputRow<String>() { row in
                row.title = "Shoe Size"
                row.tag = "Shoe Size".lowercased()
                row.options = Array(Measurements.shoeSizesArray.values.sorted(by: <))
                let data = modelManager.shoeSize()
                if data != -1 {
                    row.value = Measurements.shoeSizesArray[Float(data)]
                    
                }
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.textLabel?.textColor = .red
                    
                }
            }
            
                // if gender == female
            
            <<< PickerInputRow<String>() { row in
                row.title = "Dress Size"
                row.tag = "Dress Size".lowercased()
                row.options = Array(Measurements.dressSizesArray.values.sorted(by: <))
                let data = modelManager.dressSize()
                if data != -1 {
                    row.value = Measurements.dressSizesArray[Float(data)]
                    
                }
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.textLabel?.textColor = .red
                }
            }
                
            <<< PickerInputRow<String>() { row in
                row.title = "Ring Size"
                row.tag = "Ring Size".lowercased()
                row.options = Measurements.ringSizesArray
                row.value = modelManager.ringSize()
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
                
            <<< SwitchRow() { row in
                row.title = "Willing to colour?"
                row.value = modelManager.willingColour()
                row.tag = "Willing to colour?".lowercased()
            }
        
            <<< SwitchRow() { row in
                row.title = "Willing to cut?"
                row.value = modelManager.willingCut()
                row.tag = "Willing to cut?".lowercased()
            }
            <<< SwitchRow() { row in
                row.title = "Driving License?"
                row.value = modelManager.drivingLicense()
                row.tag = "Driving license?".lowercased()
            }
            
            <<< SwitchRow() { row in
                row.title = "Tattoos?"
                row.value = modelManager.tattoo()
                row.tag = "Tattoos?".lowercased()
            }
        } else {
            section = Section() { section in
                var header = HeaderFooterView<UIView>(.class)
                header.height = {100}
                header.onSetupView = { view, _ in
                    view.backgroundColor = UIColor.FindaColours.White
                    let title = UILabel(frame: CGRect(x:10,y: 5, width:self.view.frame.width, height:80))
                    
                    title.text = "Measurements"
                    title.font = UIFont(name: "Montserrat-Medium", size: 17)
                    view.addSubview(title)
                    
                    let description = UILabel(frame: CGRect(x:10,y: 70, width:self.view.frame.width, height:20))
                    description.numberOfLines = 0
                    description.text = "Please enter your measurements in centimeters."
                    description.font = UIFont(name: "Montserrat-Light", size: 13)
                    view.addSubview(description)
                    
                }
                section.header = header
            }
                
            <<< IntRow() { row in
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
            
            
            <<< PickerInputRow<String>() { row in
                row.title = "Shoe Size"
                row.tag = "Shoe Size".lowercased()
                row.options = Array(Measurements.shoeSizesArray.values.sorted(by: <))
                let data = modelManager.shoeSize()
                if data != -1 {
                    row.value = Measurements.shoeSizesArray[Float(data)]
                    
                }
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                        
                    }
            }
            
            <<< PickerInputRow<String>() { row in
                row.title = "Suit Size"
                row.tag = "Suit Size".lowercased()
                row.options = Array(Measurements.suitSizesArray.values.sorted(by: <))
                let data = modelManager.suitSize()
                if data != -1 {
                    row.value = Measurements.suitSizesArray[Float(data)]
                    
                }
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.textLabel?.textColor = .red
                }
            }
                
            <<< IntRow() { row in
                row.title = "Chest"
                row.tag = "Chest".lowercased()
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
                
            <<< PickerInputRow<String>() { row in
                row.title = "Collar Size"
                row.tag = "Collar Size".lowercased()
                row.options = Array(Measurements.collarSizesArray.values.sorted(by: <))
                let data = modelManager.collarSize()
                if data != -1 {
                    row.value = Measurements.collarSizesArray[Float(data)]
                    
                }
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
                
            <<< IntRow() { row in
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
                
            <<< PickerInputRow<String>() { row in
                row.title = "Ring Size"
                row.tag = "Ring Size".lowercased()
                row.options = Measurements.ringSizesArray
                row.value = modelManager.ringSize()
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
            
            <<< SwitchRow() { row in
                row.title = "Willing to colour?"
                row.value = modelManager.willingColour()
                row.tag = "Willing to colour?".lowercased()
            }
            
            <<< SwitchRow() { row in
                row.title = "Willing to cut?"
                row.value = modelManager.willingCut()
                row.tag = "Willing to cut?".lowercased()
            }

            <<< SwitchRow() { row in
                row.title = "Driving License?"
                row.value = modelManager.drivingLicense()
                row.tag = "Driving license?".lowercased()
            }
            
            <<< SwitchRow() { row in
                row.title = "Tattoos?"
                row.value = modelManager.tattoo()
                row.tag = "Tattoos?".lowercased()
            }

        }
        
        form +++ section
 
        let section1 = Section() { section1 in
            var header = HeaderFooterView<UIView>(.class)
            header.height = {60}
            header.onSetupView = { view, _ in
                view.backgroundColor = UIColor.FindaColours.White
                let title = UILabel(frame: CGRect(x:10,y: 5, width:self.view.frame.width, height:60))
                
                title.text = "Details"
                title.font = UIFont(name: "Montserrat-Medium", size: 17)
                view.addSubview(title)
                
            }
            section1.header = header
            }
            
            <<< IntRow() { row in
                row.title = "Minimum Hourly Rate"
                row.value = modelManager.hourlyrate()
                row.tag = "hourlyrate"
            }
            <<< IntRow() { row in
                row.title = "Minimum Daily Rate"
                row.value = modelManager.dailyrate()
                row.tag = "dailyrate"
        }
        
        form +++ section1
        
        PickerDelegate.addPickerData(term: .HairColour, rowTitle: "Hair Colour", coreData: modelManager.hairColour()) { (response, result, dictionary) in
            if response {
                self.hairColourDictionary = dictionary
                result.options = Array(dictionary.values.sorted(by: <))
                section.insert(result, at: section.count)
                section.reload()
            }
        }
        
        PickerDelegate.addPickerData(term: .HairType, rowTitle: "Hair Type", coreData: modelManager.hairType()) { (response, result, dictionary) in
            if response {
                self.hairTypeDictionary = dictionary
                result.options = Array(dictionary.values.sorted(by: <))
                section.insert(result, at: section.count)
                section.reload()

            }
        }
        
        PickerDelegate.addPickerData(term: .HairLength, rowTitle: "Hair Length", coreData: modelManager.hairLength()) { (response, result, dictionary) in
            if response {
                self.hairLengthDictionary = dictionary
                result.options = Array(dictionary.values.sorted(by: <))
                section.insert(result, at: section.count)
                section.reload()

            }
        }
        
        PickerDelegate.addPickerData(term: .EyeColour, rowTitle: "Eye Colour", coreData: modelManager.eyeColour()) { (response, result, dictionary) in
            if response {
                self.eyeColourDictionary = dictionary
                result.options = Array(dictionary.values.sorted(by: <))
                section.insert(result, at: section.count)
                section.reload()

            }
        }
        
        // Do any additional setup after loading the view.
        
        form +++ Section()
        form +++ Section()
        form +++ Section()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.save()
    }
    
    
    private func updateRows() {
        LoginManager.getDetails { (response, result) in
            if response {
                let model = ModelManager()
                
                if model.gender() == "female" {
                    self.updateCell(tag: "bust", data: model.bust())
                    self.updateCell(tag: "hips", data: model.hips())
                    if let dressSize: String = Measurements.dressSizesArray[Float(model.dressSize())] {
                        self.updateCell(tag: "dress size", data: dressSize)
                    }
                } else if model.gender() == "male" {
                    self.updateCell(tag: "chest", data: model.bust())
                    if let suitSize: String = Measurements.suitSizesArray[Float(model.suitSize())] {
                        self.updateCell(tag: "suit size", data: suitSize)
                    }
                    if let collarSize: String = Measurements.collarSizesArray[Float(model.collarSize())] {
                        self.updateCell(tag: "collar size", data: collarSize)
                    }
                }
                
                self.updateCell(tag: "height", data: model.height())
                self.updateCell(tag: "waist", data: model.waist())
                self.updateCell(tag: "willing to colour?", data: model.willingColour())
                self.updateCell(tag: "willing to cut?", data: model.willingCut())
                
                if let shoeSize: String = Measurements.shoeSizesArray[Float(model.shoeSize())] {
                    self.updateCell(tag: "shoe size", data: shoeSize)
                }

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
                
                self.updateCell(tag: "hourlyrate", data: model.hourlyrate())
                self.updateCell(tag: "dailyrate", data: model.dailyrate())

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
        
        let modelManager = ModelManager()
        
        if (modelManager.gender() == "female") {
        
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
            guard let dressSizeRow: BaseRow = form.rowBy(tag: "dress size"), let dressSize: String = form.values()["dress size"] as? String else {
                self.validateRow(tag: "dress size")
                return
            }
            
            guard let shoeSizeRow: BaseRow = form.rowBy(tag: "shoe size"), let shoeSize: String = form.values()["shoe size"] as? String else {
                self.validateRow(tag: "shoe size")
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
            
            let ringSize: String = form.values()["ring size"] as? String ?? ""
            
            guard let willingToColour: Bool = form.values()["willing to colour?"] as? Bool else { return }
            guard let willingToColourString: String = willingToColour ? "yes" : "no" else { return }
            
            guard let willingToCut: Bool = form.values()["willing to cut?"] as? Bool else { return }
            guard let willingToCutString: String = willingToCut ? "yes" : "no" else { return }
            
            guard let drivingLicense: Bool = form.values()["driving license?"] as? Bool else {
                return
            }
            guard let drivingLicenseString: String = drivingLicense ? "yes" : "no" else { return }
            
            guard let tattoo: Bool = form.values()["tattoos?"] as? Bool else { return }
            guard let tattooString: String = tattoo ? "yes" : "no" else { return }
            
            
            
            
            guard let shoeSizeId = Measurements.shoeSizesArray.allKeysForValue(val: shoeSize).first else {
                return
            }
            
            guard let dressSizeId = Measurements.dressSizesArray.allKeysForValue(val: dressSize).first else {
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
        
            let hourlyrate: Int = form.values()["hourlyrate"] as? Int ?? 0
            let dailyrate: Int = form.values()["dailyrate"] as? Int ?? 0
            
        
            if (heightRow.isValid && bustRow.isValid && waistRow.isValid && hipsRow.isValid && shoeSizeRow.isValid && dressSizeRow.isValid && hairColourRow.isValid && hairLengthRow.isValid && hairTypeRow.isValid && eyeColourRow.isValid) {
                FindaAPISession(target: .updateMeasurements(height: height, bust: bust, waist: waist, hips: hips, shoeSize: shoeSizeId, collarSize: 0, dressSize: dressSizeId, suitSize: 0, hairColour: hairColourId, hairLength: hairLengthId, hairType: hairTypeId, eyeColour: eyeColourId, ringSize: ringSize, willingToColour: willingToColourString, willingToCut: willingToCutString, drivingLicense: drivingLicenseString, tattoo: tattooString, hourlyrate: hourlyrate, dailyrate: dailyrate)) { (response, result) in
                    if response {
                        self.updateRows()
                    }
                }
            }
        } else {
            // male
            guard let heightRow: BaseRow = form.rowBy(tag: "height"), let height: Int = form.values()["height"] as? Int else {
                self.validateRow(tag: "height")
                return
            }
            
            guard let chestSizeRow: BaseRow = form.rowBy(tag: "chest"), let chestSize: Int = form.values()["chest"] as? Int else {
                self.validateRow(tag: "chest")
                return
            }
            
            guard let collarSizeRow: BaseRow = form.rowBy(tag: "collar size"), let collarSize: String = form.values()["collar size"] as? String else {
                self.validateRow(tag: "collar size")
                return
            }
   
            guard let waistRow: BaseRow = form.rowBy(tag: "waist"), let waistSize: Int = form.values()["waist"] as? Int else {
                self.validateRow(tag: "waist")
                return
            }
            
            guard let suitSizeRow: BaseRow = form.rowBy(tag: "suit size"), let suitSize: String = form.values()["suit size"] as? String else {
                self.validateRow(tag: "suit size")
                return
            }
            
            guard let shoeSizeRow: BaseRow = form.rowBy(tag: "shoe size"), let shoeSize: String = form.values()["shoe size"] as? String else {
                self.validateRow(tag: "shoe size")
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
            
            let ringSize: String = form.values()["ring size"] as? String ?? ""
  
            guard let collarSizeId = Measurements.collarSizesArray.allKeysForValue(val: collarSize).first else {
                return
            }
            
            guard let willingToColour: Bool = form.values()["willing to colour?"] as? Bool else { return }
            guard let willingToColourString: String = willingToColour ? "yes" : "no" else { return }
            
            guard let willingToCut: Bool = form.values()["willing to cut?"] as? Bool else { return }
            guard let willingToCutString: String = willingToCut ? "yes" : "no" else { return }
            
            guard let drivingLicense: Bool = form.values()["driving license?"] as? Bool else { return }
            guard let drivingLicenseString: String = drivingLicense ? "yes" : "no" else { return }
            
            guard let tattoo: Bool = form.values()["tattoos?"] as? Bool else { return }
            guard let tattooString: String = tattoo ? "yes" : "no" else { return }
            
            
            guard let shoeSizeId = Measurements.shoeSizesArray.allKeysForValue(val: shoeSize).first else {
                return
            }
            
            guard let suitSizeId = Measurements.suitSizesArray.allKeysForValue(val: suitSize).first else {
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
            
            let hourlyrate: Int = form.values()["hourlyrate"] as? Int ?? 0
            let dailyrate: Int = form.values()["dailyrate"] as? Int ?? 0
            
            if (heightRow.isValid && shoeSizeRow.isValid && suitSizeRow.isValid && hairColourRow.isValid && hairLengthRow.isValid && hairTypeRow.isValid && eyeColourRow.isValid) {
                FindaAPISession(target: .updateMeasurements(height: height, bust: chestSize, waist: waistSize, hips: 0, shoeSize: shoeSizeId, collarSize: collarSizeId, dressSize: 0, suitSize: suitSizeId, hairColour: hairColourId, hairLength: hairLengthId, hairType: hairTypeId, eyeColour: eyeColourId, ringSize: ringSize, willingToColour: willingToColourString, willingToCut: willingToCutString, drivingLicense: drivingLicenseString, tattoo: tattooString, hourlyrate: hourlyrate, dailyrate: dailyrate)) { (response, result) in
                    if response {
                        self.updateRows()
                    }
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
                                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.FindaColours.FindaRed])
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
