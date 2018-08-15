//
//  PersonalDetailsVC.swift
//  Finda
//
//  Created by Peter Lloyd on 24/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import Eureka

class PersonalDetailsVC: FormViewController {
    
    
    var ethnicityDictionary: [Int: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let modelManager = ModelManager()
        
        
//        self.tableView?.backgroundColor = UIColor.FindaColors.Purple
//        self.navigationController?.navigationBar.backgroundColor = UIColor.FindaColors.Purple
        
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textField.font = UIFont(name: "Gotham-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Gotham-Light", size: 16)
        }
        
        EmailRow.defaultCellUpdate = { cell, row in
            cell.textField.font = UIFont(name: "Gotham-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Gotham-Light", size: 16)
        }
        
        IntRow.defaultCellUpdate = { cell, row in
            cell.textField.font = UIFont(name: "Gotham-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Gotham-Light", size: 16)
        }
        
        DateInlineRow.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = UIFont(name: "Gotham-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Gotham-Light", size: 16)
        }
        
        PickerInlineRow<String>.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = UIFont(name: "Gotham-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Gotham-Light", size: 16)
        }
        
        
        
        
        var section = Section(){ section in
            var header = HeaderFooterView<UIView>(.class)
            header.height = {70}
            header.onSetupView = { view, _ in
                view.backgroundColor = UIColor.FindaColors.White
                let title = UILabel(frame: CGRect(x:10,y: 5, width:self.view.frame.width, height:40))
                
                title.text = "Personal Details"
                title.font = UIFont(name: "Gotham-Medium", size: 17)
                view.addSubview(title)
                
                let description = UILabel(frame: CGRect(x:10,y: 40, width:self.view.frame.width, height:20))
                description.numberOfLines = 0
                description.text = "Please enter your contact information."
                description.font = UIFont(name: "Gotham-Light", size: 13)
                view.addSubview(description)
                
            }
            section.header = header
            }
            
            <<< TextRow(){ row in
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
            
            <<< TextRow(){ row in
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
            
            <<< DateInlineRow(){ row in
                row.title = "Date of Birth"
                
                var components = DateComponents()
                components.year = -18
                row.minimumDate = Calendar.current.date(byAdding: components, to: Date())
                row.tag = "dob"
                
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
            
            <<< EmailRow(){ row in
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
            
            
            <<< PickerInlineRow<String>() { row in
                row.title = "Gender"
                
                row.options = ["Female", "Male"]
                row.value = modelManager.gender().capitalizingFirstLetter()
                row.tag = "gender"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                        
                    }
            }
            
            
            <<< PickerInlineRow<String>() { row in
                row.title = "Nationality"
                row.tag = "nationality"
                
                row.options = Country.nationalities
                let nationality = modelManager.nationality()
                row.value = nationality
                if nationality != "" {
                    row.disabled = true
                }
            }
            
            <<< PickerInlineRow<String>() { row in
                row.title = "Country of residence"
                row.tag = "residence"
                
                row.options = Country.nationalities
                let residenceCountry = modelManager.residenceCountry()
                row.value = residenceCountry
    
                if residenceCountry != "" {
                    row.disabled = true
                }
            }
            
            <<< TextRow(){ row in
                row.title = "Instagram Username"
                row.value = modelManager.instagramUserName()
                row.tag = "instagramUsername"
            }
            
            <<< IntRow(){ row in
                row.title = "Followers"
                row.disabled = true
                let instagramFollowers = modelManager.instagramFollowers()
                if instagramFollowers != -1 {
                    row.value = instagramFollowers
                }
                
                
                
            }
            <<< TextRow(){ row in
                row.title = "Referral Code"
                row.tag = "referralCode"
                row.value = modelManager.referrerCode()
                
                
            }
            
            //            <<< IntRow(){ row in
            //                row.title = "Minimum Hourly Rate"
            //                if CoreDataManager.getInt(dataName: "instagramFollowers", entity: "User") != -1 {
            //                    row.value = CoreDataManager.getInt(dataName: "instagramFollowers", entity: "User")
            //                }
            //
            //            }
            //            <<< IntRow(){ row in
            //                row.title = "Minimum Daily Rate"
            //                if CoreDataManager.getInt(dataName: "instagramFollowers", entity: "User") != -1 {
            //                    row.value = CoreDataManager.getInt(dataName: "instagramFollowers", entity: "User")
            //                }
            //
            //            }
            
            <<< TextRow(){ row in
                row.title = "VAT Number"
                row.placeholder = "(optional)"
                row.value = modelManager.vatNumber()
                row.tag = "vat"
                
        }
        
        form +++ section
        
        PickerDelegate.addPickerData(term: .Ethnicity, rowTitle: "Ethnicity", coreData: modelManager.ethnicity()) { (response, result, dictionary) in
            if response {
                self.ethnicityDictionary = dictionary
                section.insert(result, at: 5)
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateRows()
    }
    
    private func updateRows(){
        LoginManager.getDetails { (response, result) in
            if response {
                let model = ModelManager()
                self.updateCell(tag: "firstName", data: model.firstName())
                self.updateCell(tag: "lastName", data: model.lastName())
                
                let date: Int = model.dateOfBirth()
                if date != -1 {
                    self.updateCell(tag: "dob", data: Date(timeIntervalSince1970: TimeInterval(date)))
                }
                self.updateCell(tag: "email", data: model.email())
                self.updateCell(tag: "gender", data: model.gender())
                
            }
            
        }
    }
    
    private func updateCell(tag: String, data: Any){
        guard let row: BaseRow = form.rowBy(tag: tag) else { return }
        row.baseValue = data
        row.updateCell()
    }
    
    
    @IBAction func save(_ sender: Any) {
        
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
        
        guard let genderRow: BaseRow = form.rowBy(tag: "gender"), let gender: String = form.values()["gender"] as? String else {
            self.validateRow(tag: "gender")
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
        
        guard let referralCodeRow: BaseRow = form.rowBy(tag: "referralCode"), let referralCode: String = form.values()["referralCode"] as? String else {
            self.validateRow(tag: "referralCode")
            return
        }
        
        guard let vatRow: BaseRow = form.rowBy(tag: "vat"), let vat: String = form.values()["vat"] as? String else {
            self.validateRow(tag: "vat")
            return
        }
        
        

        guard let ethnictyId = ethnicityDictionary.allKeysForValue(val: ethnicity).first else {
            return
        }
        
        if(firstNameRow.isValid && lastNameRow.isValid && emailRow.isValid && genderRow.isValid && ethnicityRow.isValid && instagramRow.isValid){
            FindaAPISession(target: .updateProfile(firstName: firstName, lastName: lastName,  email: email, gender: gender, ethnicityId: ethnictyId, instagramUsername: instagram, referralCode: referralCode, vatNumber: vat)) { (response, result) in
                if response {
                    
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

