//
//  ModelRegisterVC.swift
//  Finda
//
//  Created by Peter Lloyd on 29/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import Eureka
import DCKit

class ModelRegisterVC: FormViewController, UITextViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let montserratLight = UIFont(name: "Montserrat-Light", size: 16)
        
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        view.addSubview(subView)
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textField.font = montserratLight
            cell.textLabel?.font = montserratLight
            cell.tintColor = .black
        }
        
        DateInlineRow.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = montserratLight
            cell.textLabel?.font = montserratLight
        }
        
        EmailRow.defaultCellUpdate = { cell, row in
            cell.textField.font = montserratLight
            cell.textLabel?.font = montserratLight
            cell.tintColor = .black
        }
        
        TwitterRow.defaultCellUpdate = { cell, row in
            cell.textField.font = montserratLight
            cell.textLabel?.font = montserratLight
        }
        
        PasswordRow.defaultCellUpdate = { cell, row in
            cell.textField.font = montserratLight
            cell.textLabel?.font = montserratLight
        }
        
        PickerInlineRow<String>.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = montserratLight
            cell.textLabel?.font = montserratLight
        }
        
        
        let section = Section() { section in
            
            section.footer = self.footerView()
            
            var header = HeaderFooterView<UIView>(.class)
            header.height = {80}
            header.onSetupView = { view, _ in
                view.backgroundColor = UIColor.FindaColours.White
                let title = UILabel(frame: CGRect(x:10,y: 5, width:self.view.frame.width - 10, height:80))
                
                title.text = "I'M A MODEL"
                title.font = UIFont(name: "Montserrat-Medium", size: 17)
                view.addSubview(title)
                
            }
            section.header = header
            }
            
            <<< TextRow() { row in
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
            
            <<< TextRow() { row in
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
            
            
            <<< PickerInlineRow<String>() { row in
                row.title = "Country of Residence"
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
        
            
            
            <<< EmailRow() { row in
                row.title = "Email"
                row.tag = "email"
                row.add(rule: RuleRequired())
                row.add(rule: RuleEmail())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< PhoneRow() { row in
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
            
            <<< TwitterRow() { row in
                row.title = "Instagram"
                row.tag = "instagram"
                row.value = "@"
                
                row.add(rule: RuleRequired())
                row.add(rule: RuleRegExp(regExpr: "@.+"))
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .onChange({ (row) in
                    if let value = row.value{
                        if value.first != "@" {
                            row.value = "@\(value)"
                        }
                    }
                })
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                    if !self.isValidInstagram(Input: row.value ?? "") {
                        cell.titleLabel?.textColor = .red
                    }
                }
            
            
            <<< DateInlineRow() { row in
                row.title = "Date of Birth"
                row.tag = "dob"
                row.value = Date()
                
                var components = DateComponents()
                components.year = -18
                row.maximumDate = Calendar.current.date(byAdding: components, to: Date())
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
            
            <<< PickerInlineRow<String>() { row in
                row.title = "I identify as"
                row.tag = "gender"
                
                row.options = ["Woman", "Man", "Non-binary"]
                row.value = "Woman"
                row.add(rule: RuleRequired())
                row.add(rule: RuleMinLength(minLength: 1))
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
            
            
            <<< TextRow() { row in
                row.title = "Referral Code"
                row.placeholder = "(optional)"
                row.tag = "referralCode"
            }
            
            <<< PasswordRow() { row in
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
            
            <<< PasswordRow() { row in
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
            <<< CheckRow() { row in
                row.title = "I agree to the Terms and Conditions"
                row.tag = "terms"
                row.add(rule: RuleRequired())
                }.onCellSelection { cell, row in
                    cell.backgroundColor = UIColor.FindaColours.Burgundy
                    cell.textLabel?.textColor = UIColor.white
            }
        
        
        form +++ section
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .default
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
    
    @objc func signUp() {
        
        guard let firstnameRow: BaseRow = form.rowBy(tag: "firstName"), let firstname: String = firstnameRow.baseValue as? String else {
            self.validateRow(tag: "firstName")
            return
        }

        guard let lastnameRow: BaseRow = form.rowBy(tag: "lastName"), let lastname: String = form.values()["lastName"] as? String else {
            self.validateRow(tag: "lastName")
            return
        }
        guard let genderRow: BaseRow = form.rowBy(tag: "gender"), let gender: String = form.values()["gender"] as? String else {
            self.validateRow(tag: "gender")
            return
        }
        guard let countryRow: BaseRow = form.rowBy(tag: "country"), let country: String = form.values()["country"] as? String else {
            self.validateRow(tag: "country")
            return
        }
        guard let mailRow: BaseRow = form.rowBy(tag: "email"), let mail: String = form.values()["email"] as? String else {
            self.validateRow(tag: "email")
            return
        }
        guard let telephoneRow: BaseRow = form.rowBy(tag: "telephone"), let telephone: String = form.values()["telephone"] as? String else {
            self.validateRow(tag: "telephone")
            return
        }
        guard let instagram_usernameRow: BaseRow = form.rowBy(tag: "instagram"), let instagram_username: String = form.values()["instagram"] as? String else {
            self.validateRow(tag: "instagram")
            return
        }
        
        let referral_code: String = form.values()["referralCode"] as? String ?? ""
        
        guard let passwordRow: BaseRow = form.rowBy(tag: "password"), let password: String = form.values()["password"] as? String else {
            self.validateRow(tag: "password")
            return
        }
        guard let repeatPasswordRow: BaseRow = form.rowBy(tag: "repeatPassword"), let repeatPassword: String = form.values()["repeatPassword"] as? String else {
            self.validateRow(tag: "repeatPassword")
            return
        }
        guard let dobRow: BaseRow = form.rowBy(tag: "dob"), let dob: Date = form.values()["dob"] as? Date else {
            self.validateRow(tag: "dob")
            return
        }
        
        if password != repeatPassword {
            let password: PasswordRow? = form.rowBy(tag: "password")
            password?.cell.textLabel?.textColor = UIColor.red
            
            let repeatPassword: PasswordRow? = form.rowBy(tag: "repeatPassword")
            repeatPassword?.cell.textLabel?.textColor = UIColor.red
            return
        }
        
        if !isValidInstagram(Input: instagram_username) {
            let instagramName: TextRow? = form.rowBy(tag: "instagram")
            instagramName?.cell.textLabel?.textColor = UIColor.red
            return
        }
        
        if (mailRow.isValid && passwordRow.isValid && repeatPasswordRow.isValid && firstnameRow.isValid && lastnameRow.isValid && genderRow.isValid && telephoneRow.isValid && countryRow.isValid && instagram_usernameRow.isValid && dobRow.isValid) {
            
            RegisterManager.model(mail: mail, pass: password, firstname: firstname, lastname: lastname, gender: gender, country: country, instagram_username: instagram_username, telephone: telephone, referral_code: referral_code, dob: dob.timeIntervalSince1970) { (response, result) in
                if(response){
                    self.performSegue(withIdentifier: "editProfileSegue", sender: nil)
                }
            }
        } else {
            print("not valid")
        }
    }
    
    func validateRow(tag: String) {
        let row: BaseRow? = form.rowBy(tag: tag)
        _ = row?.validate()
    }
    
    func isValidInstagram(Input:String) -> Bool {
        let RegEx = "@([A-Za-z0-9_](?:(?:[A-Za-z0-9_]|(?:\\.(?!\\.))){0,28}(?:[A-Za-z0-9_]))?)"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    
    func footerView() -> HeaderFooterView<UIView> {
        
        var footer = HeaderFooterView<UIView>(.class)
        footer.height = {200}
        footer.onSetupView = { view, _ in
            view.addSubview(RegisterFooter.legalFooter(width: self.view.frame.width))
            
            let button = RegisterFooter.signUpButton(width: self.view.frame.width)
            button.addTarget(self, action:#selector(self.signUp), for: UIControl.Event.touchUpInside)
            view.addSubview(button)
            
        }
        return footer
    }
    
}
