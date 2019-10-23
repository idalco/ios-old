//
//  PersonalDetailsVC.swift
//  Finda
//
//  Created by Peter Lloyd on 24/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import Eureka
import SVProgressHUD

class PersonalDetailsVC: FormViewController {
    
    
    var ethnicityDictionary: [Int: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.backgroundColor = UIColor.white
        self.updateRows()
        let modelManager = ModelManager()
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textField.font = UIFont(name: "Montserrat-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
        }
        
        PhoneRow.defaultCellUpdate = { cell, row in
            cell.textField.font = UIFont(name: "Montserrat-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
        }
        
        EmailRow.defaultCellUpdate = { cell, row in
            cell.textField.font = UIFont(name: "Montserrat-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
        }
        
        IntRow.defaultCellUpdate = { cell, row in
            cell.textField.font = UIFont(name: "Montserrat-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
        }
        
        DateInlineRow.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
        }

        DateRow.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
        }
        
        PickerInlineRow<String>.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
        }
        
        PickerInputRow<String>.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
        }
        
        SwitchRow.defaultCellSetup = { cell, row in
            cell.detailTextLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Montserrat-Light", size: 16)
        }
        
    
        let locationSection = Section("Location") { section in
            var header = HeaderFooterView<UIView>(.class)
            header.height = {100}
            header.onSetupView = { view, _ in
                view.backgroundColor = UIColor.FindaColours.White
                let title = UILabel(frame: CGRect(x:10,y: 5, width:self.view.frame.width, height:80))
                
                title.text = "Location"
                title.font = UIFont(name: "Montserrat-Medium", size: 17)
                view.addSubview(title)
                
                let description = UILabel(frame: CGRect(x:10,y: 70, width:self.view.frame.width, height:20))
                description.numberOfLines = 0
                description.text = "Set your current location to book jobs where you are"
                description.font = UIFont(name: "Montserrat-Light", size: 13)
                view.addSubview(description)
                
            }
            section.header = header
        }
        <<< PickerInputRow<String>() { row in
            row.title = "Location"
            row.tag = "location"
            
            row.options = Locations.locations
            let nationality = modelManager.location()
            row.value = Locations().getNameFromTid(tid: nationality)
            
        }
        
        form +++ locationSection
        
        var mainSection = Section("Main") { section in
            var header = HeaderFooterView<UIView>(.class)
            header.height = {100}
            header.onSetupView = { view, _ in
                view.backgroundColor = UIColor.FindaColours.White
                let title = UILabel(frame: CGRect(x:10,y: 5, width:self.view.frame.width, height:80))
                
                title.text = "Personal Details"
                title.font = UIFont(name: "Montserrat-Medium", size: 17)
                view.addSubview(title)
                
                let description = UILabel(frame: CGRect(x:10,y: 70, width:self.view.frame.width, height:20))
                description.numberOfLines = 0
                description.text = "Please enter your contact information."
                description.font = UIFont(name: "Montserrat-Light", size: 13)
                view.addSubview(description)
                
            }
            section.header = header
        }
            
        <<< TextRow() { row in
            row.title = "First name"
            row.value = modelManager.firstName()
            row.tag = "firstName"
            row.add(rule: RuleRequired())
            row.validationOptions = .validatesOnChangeAfterBlurred
        }
        .cellUpdate { cell, row in
            if !row.isValid {
                cell.textLabel?.textColor = .red
                
            }
        }
        
        <<< TextRow() { row in
            row.title = "Last name"
            row.value = modelManager.lastName()
            row.tag = "lastName"
            row.add(rule: RuleRequired())
            row.validationOptions = .validatesOnChangeAfterBlurred
        }
        .cellUpdate { cell, row in
            if !row.isValid {
                cell.textLabel?.textColor = .red
                
            }
        }
        
        <<< DateRow() { row in
            row.title = "Date of Birth"
            row.tag = "dob"
            
            var components = DateComponents()
            components.year = -18
            row.maximumDate = Calendar.current.date(byAdding: components, to: Date())
            
            let data = modelManager.dateOfBirth()
            if data != -1 {
                row.value = Date(timeIntervalSince1970: TimeInterval(data))
                row.disabled = true
            }
            row.add(rule: RuleRequired())
            row.validationOptions = .validatesOnChangeAfterBlurred
        }
        .cellUpdate { cell, row in
            if !row.isValid {
                cell.textLabel?.textColor = .red
            }
        }
        
        <<< EmailRow() { row in
            row.title = "Email address"
            row.value = modelManager.email()
            row.tag = "email"
            row.add(rule: RuleRequired())
            row.add(rule: RuleEmail())
            row.validationOptions = .validatesOnChangeAfterBlurred
        }
        .cellUpdate { cell, row in
            if !row.isValid {
                cell.textLabel?.textColor = .red
                
            }
        }
        
        <<< PhoneRow() { row in
            row.title = "Mobile Number"
            row.placeholder = "Mobile Number"
            row.value = modelManager.telephone()
            row.tag = "telephone"
           
        }
            
        <<< PickerInputRow<String>() { row in
            row.title = "Nationality"
            row.tag = "nationality"
            
            row.options = Country.nationalities
            let nationality = modelManager.nationality()
            row.value = nationality
            if nationality != "" {
                row.disabled = true
            }
        }
        
        <<< PickerInputRow<String>() { row in
            row.title = "Country of residence"
            row.tag = "residence"
            
            
            
            row.options = Country.nationalities
            let residenceCountry = modelManager.residenceCountry()
            row.value = residenceCountry

            if residenceCountry != "" {
                row.disabled = true
            }
        }
        
        <<< TextRow() { row in
            row.title = "Instagram Username"
            row.value = modelManager.instagramUserName()
            row.tag = "instagramUsername"
        }
        
        <<< IntRow() { row in
            row.title = "Followers"
            row.disabled = true
            let instagramFollowers = modelManager.instagramFollowers()
            if instagramFollowers != -1 {
                row.value = instagramFollowers
            }
           
            
        }
        <<< TextRow() { row in
            row.title = "Referral Code"
            row.placeholder = "(optional)"
            row.tag = "referralCode"
            row.value = modelManager.referrerCode()
        }
        
        
        <<< TextRow() { row in
            row.title = "VAT Number"
            row.placeholder = "(optional)"
            row.value = modelManager.vatNumber()
            row.tag = "vat"

        }
        
        form +++ mainSection
        
        form +++ Section("Visibility")
            <<< SwitchRow("allday") { row in
                row.title = "Hide my account"
                row.tag = "availability"
                row.cell.switchControl.onTintColor = UIColor.FindaColours.Burgundy
                row.cell.backgroundColor = UIColor.FindaColours.White
            }
            .cellSetup({ (SwitchCell, SwitchRow) in
                if modelManager.available() {
                    (self.form.rowBy(tag: "availability") as? SwitchRow)?.cell.switchControl.isOn = true
                }
                self.tableView.reloadData()
            })
            .onChange({ row in
                self.toggleAvailability()
                self.tableView.reloadData()
            })
        
        form +++ Section()
        form +++ Section()
        form +++ Section()
        
        PickerDelegate.addPickerData(term: .Ethnicity, rowTitle: "Ethnicity", coreData: modelManager.ethnicity()) { (response, result, dictionary) in
            if response {
                self.ethnicityDictionary = dictionary
                result.options = dictionary.values.sorted(by: <)
                mainSection.insert(result, at: 5)
                mainSection.reload()

            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.save()
    }
    
    private func updateRows() {
        LoginManager.getDetails { (response, result) in
            if response {
                let model = ModelManager()
                
                print(model.firstName())
                
                self.updateCell(tag: "firstName", data: model.firstName())
                self.updateCell(tag: "lastName", data: model.lastName())
                
                let date: Int = model.dateOfBirth()
                if date != -1 {
                    self.updateCell(tag: "dob", data: Date(timeIntervalSince1970: TimeInterval(date)))
                }
                self.updateCell(tag: "email", data: model.email())
                self.updateCell(tag: "telephone", data: model.telephone())
                self.updateGenderPickerRow(tag: "gender", data: model.gender())
              
                self.updateCell(tag: "nationality", data: model.nationality())
                self.updateCell(tag: "residence", data: model.residenceCountry())
                self.updateCell(tag: "instagramUsername", data: model.instagramUserName())
                self.updateCell(tag: "referralCode", data: model.referrerCode())
                self.updateCell(tag: "vat", data: model.vatNumber())
                
                let location = model.location()
                let locationName = Locations().getNameFromTid(tid: location)
                self.updateCell(tag: "location", data: locationName)
                
                guard let row: PickerInputRow<String> = self.form.rowBy(tag: "ethnicity") else { return }
                if self.ethnicityDictionary.count > 0 {
                    self.updatePickerRow(row: row, coreData: model.ethnicity(), dictionary: self.ethnicityDictionary)
                }
                
                
            }
        }
    }
    
    private func updateCell(tag: String, data: Any) {
        guard let row: BaseRow = form.rowBy(tag: tag) else { return }
        row.baseValue = data
        row.updateCell()
    }
    
    private func updatePickerRow(row: PickerInputRow<String>, coreData: Int, dictionary: [Int:String]) {
        row.options = Array(dictionary.values)
        row.value = dictionary[coreData] ?? ""
        row.updateCell()
    }
    
    private func updateBooleanPickerRow(tag: String, data: String) {
        guard let row: PickerInputRow<String> = form.rowBy(tag: tag) else { return }
        row.options = Array(BooleanDictionary.values)
        row.value = data.capitalizingFirstLetter()
        row.updateCell()
    }
    
    private func updateGenderPickerRow(tag: String, data: String) {
        guard let row: PickerInputRow<String> = form.rowBy(tag: tag) else { return }
        row.options = GenderArray
        row.value = data.capitalizingFirstLetter()
        row.updateCell()
    }
    
    
    func save() {
        
        guard let firstNameRow: BaseRow = form.rowBy(tag: "firstName"), let firstName: String = form.values()["firstName"] as? String else {
            self.validateRow(tag: "firstName")
            return
        }
        
        guard let lastNameRow: BaseRow = form.rowBy(tag: "lastName"), let lastName: String = form.values()["lastName"] as? String else {
            self.validateRow(tag: "lastName")
            return
        }

        guard let emailRow: BaseRow = form.rowBy(tag: "email"), let email: String = form.values()["email"] as? String else {
            self.validateRow(tag: "email")
            return
        }
        
        guard let ethnicityRow: BaseRow = form.rowBy(tag: "ethnicity"), let ethnicity: String = form.values()["ethnicity"] as? String else {
            self.validateRow(tag: "ethnicity")
            return
        }
        
        guard let instagramRow: BaseRow = form.rowBy(tag: "instagramUsername"), let instagram: String = form.values()["instagramUsername"] as? String else {
            self.validateRow(tag: "instagramUsername")
            return
        }
        
        guard let ethnictyId = ethnicityDictionary.allKeysForValue(val: ethnicity).first else {
            return
        }
        
        guard let _: BaseRow = form.rowBy(tag: "nationality"), let nationality: String = form.values()["nationality"] as? String else {
            self.validateRow(tag: "nationality")
            return
        }

        guard let _: BaseRow = form.rowBy(tag: "residence"), let residence: String = form.values()["residence"] as? String else {
            self.validateRow(tag: "residence")
            return
        }

        let referralCode: String = form.values()["referralCode"] as? String ?? ""
        let vat: String = form.values()["vat"] as? String ?? ""
        let telephone: String = form.values()["telephone"] as? String ?? ""
        
        let locationName: String = form.values()["location"] as? String ?? "London"
        let tid = Locations().getTidFromName(name: locationName)
        
        if(firstNameRow.isValid && lastNameRow.isValid && emailRow.isValid && ethnicityRow.isValid && instagramRow.isValid) {
            FindaAPISession(target: .updateProfile(firstName: firstName, lastName: lastName,  email: email, telephone: telephone, nationality: nationality, residence_country: residence, ethnicityId: ethnictyId, instagramUsername: instagram, referralCode: referralCode, vatNumber: vat, locationTid: tid)) { (response, result) in
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
                                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.FindaColours.FindaRed])
            }
        }
    }
    
    @IBAction func menu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    func toggleAvailability() {
        var availability = 1
        let values = form.values()
        let availToggle = (values["availability"] as? Bool) ?? false
        if availToggle {
            availability = 0
        }
        
        FindaAPISession(target: .updateAvailability(availability: availability)) { (response, result) in
            if response {

            } else {
                SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Blue)
                SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
                SVProgressHUD.showError(withStatus: "There was a problem saving your availability")
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView?.backgroundColor = UIColor.FindaColours.White
            view.textLabel?.backgroundColor = UIColor.clear
            view.textLabel?.textColor = UIColor.FindaColours.Black
            view.textLabel?.font = UIFont(name: "Montserrat-Medium", size: 16)
            view.textLabel?.text? = view.textLabel?.text?.capitalized ?? ""
        }
    }
    
}

