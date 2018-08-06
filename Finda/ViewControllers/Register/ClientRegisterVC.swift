//
//  ClientRegisterVC.swift
//  Finda
//
//  Created by Peter Lloyd on 29/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import Eureka
import DCKit

class ClientRegisterVC: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textField.font = UIFont(name: "Gotham-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Gotham-Light", size: 16)
        }
        
        EmailRow.defaultCellUpdate = { cell, row in
            cell.textField.font = UIFont(name: "Gotham-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Gotham-Light", size: 16)
        }
        
        URLRow.defaultCellUpdate = { cell, row in
            cell.textField.font = UIFont(name: "Gotham-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Gotham-Light", size: 16)
        }
        
        PhoneRow.defaultCellUpdate = { cell, row in
            cell.textField.font = UIFont(name: "Gotham-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Gotham-Light", size: 16)
        }
        
        PasswordRow.defaultCellUpdate = { cell, row in
            cell.textField.font = UIFont(name: "Gotham-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Gotham-Light", size: 16)
        }
        
        PickerInlineRow<String>.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = UIFont(name: "Gotham-Light", size: 16)
            cell.textLabel?.font = UIFont(name: "Gotham-Light", size: 16)
        }
        
        
        let section = Section(){ section in
            
            section.footer = self.footerView()
            
            
            var header = HeaderFooterView<UIView>(.class)
            header.height = {40}
            header.onSetupView = { view, _ in
                view.backgroundColor = UIColor.FindaColors.White
                let title = UILabel(frame: CGRect(x:10,y: 5, width:self.view.frame.width, height:40))
                
                title.text = "I'M A CLIENT"
                title.font = UIFont(name: "Gotham-Medium", size: 17)
                view.addSubview(title)
            }
            section.header = header
            }
            
            <<< TextRow(){ row in
                row.title = "First Name"
                row.tag = "firstName"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< TextRow(){ row in
                row.title = "Last Name"
                row.tag = "lastName"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< TextRow(){ row in
                row.title = "Company Name"
                row.tag = "companyName"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< EmailRow(){ row in
                row.title = "Company Email"
                row.tag = "companyEmail"
                row.add(rule: RuleRequired())
                row.add(rule: RuleEmail())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            
            <<< TextRow(){ row in
                row.title = "Company Website"
                row.tag = "companyWebsite"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< TextRow(){ row in
                row.title = "Position"
                row.tag = "position"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< PhoneRow(){ row in
                row.title = "Telephone"
                row.tag = "telephone"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< PickerInlineRow<String>() { row in
                row.title = "Country"
                row.tag = "country"
                row.options = Country.nationalities
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
               
                    }
            }

            
            <<< PasswordRow(){ row in
                row.title = "Password"
                row.tag = "password"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< PasswordRow(){ row in
                row.title = "Repeat Password"
                row.tag = "repeatPassword"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
        }
        
        
        form +++ section
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    @objc func signUp(){
        guard let firstNameRow: BaseRow = form.rowBy(tag: "firstName"), let firstName: String = form.values()["firstName"]  as? String else {
            self.validateRow(tag: "firstName")
            return
        }
        
        guard let lastNameRow: BaseRow = form.rowBy(tag: "lastName"), let lastname: String = form.values()["lastName"] as? String else {
            self.validateRow(tag: "lastName")
            return
        }
        guard let companyNameRow: BaseRow = form.rowBy(tag: "companyName"), let companyName: String = form.values()["companyName"] as? String else {
            self.validateRow(tag: "companyName")
            return
        }
        guard let companyEmailRow: BaseRow = form.rowBy(tag: "companyEmail"), let companyEmail: String = form.values()["companyEmail"] as? String else {
            self.validateRow(tag: "companyEmail")
            return
        }
        guard let companyWebsiteRow: BaseRow = form.rowBy(tag: "companyWebsite"), let companyWebsite: String = form.values()["companyWebsite"] as? String else {
            self.validateRow(tag: "companyWebsite")
            return
        }
        guard let positionRow: BaseRow = form.rowBy(tag: "position"), let position: String = form.values()["position"] as? String else {
            self.validateRow(tag: "position")
            return
        }
        guard let telephoneRow: BaseRow = form.rowBy(tag: "telephone"), let telephone: String = form.values()["telephone"] as? String else {
            self.validateRow(tag: "telephone")
            return
        }
        
        guard let countryRow: BaseRow = form.rowBy(tag: "country"), let country: String = form.values()["country"] as? String else {
            self.validateRow(tag: "country")
            return
        }
        guard let passwordRow: BaseRow = form.rowBy(tag: "password"), let password: String = form.values()["password"] as? String else {
            self.validateRow(tag: "password")
            return
        }
        guard let repeatPasswordRow: BaseRow = form.rowBy(tag: "repeatPassword"), let repeatPassword: String = form.values()["repeatPassword"] as? String else {
            self.validateRow(tag: "repeatPassword")
            return
        }
        
        if password != repeatPassword {
            let password: PasswordRow? = form.rowBy(tag: "password")
            password?.cell.textLabel?.textColor = UIColor.red
            
            let repeatPassword: PasswordRow? = form.rowBy(tag: "repeatPassword")
            repeatPassword?.cell.textLabel?.textColor = UIColor.red
            return
        }
        
        if(firstNameRow.isValid && lastNameRow.isValid && companyNameRow.isValid && companyEmailRow.isValid && companyWebsiteRow.isValid && positionRow.isValid && telephoneRow.isValid && countryRow.isValid && passwordRow.isValid && repeatPasswordRow.isValid) {
            
            RegisterManager.client(mail: companyEmail, pass: password, firstname: firstName, lastname: lastname, telephone: telephone, occupation: position, company_name: companyName, company_website: companyWebsite, country: country) { (response, result) in
                if(response){
                    self.performSegue(withIdentifier: "finishSegue", sender: nil)
                    print("Registered Successful")
                }
            }
        }
    }
    
    func validateRow(tag: String){
        let row: BaseRow? = form.rowBy(tag: tag)
        _ = row?.validate()
    }
    
    func footerView() -> HeaderFooterView<UIView> {
        
        var footer = HeaderFooterView<UIView>(.class)
        footer.height = {200}
        footer.onSetupView = { view, _ in
            
  
            view.addSubview(RegisterFooter.legalFooter(width: self.view.frame.width))
            
            let button = RegisterFooter.signUpButton(width: self.view.frame.width)
            button.addTarget(self, action:#selector(self.signUp), for: UIControlEvents.touchUpInside)
            view.addSubview(button)
            
        }
        return footer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
