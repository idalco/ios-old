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
        
        let gothamLight = UIFont(name: "Gotham-Light", size: 16)
        
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        view.addSubview(subView)
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textField.font = gothamLight
            cell.textLabel?.font = gothamLight
        }
        
        DateInlineRow.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = gothamLight
            cell.textLabel?.font = gothamLight
        }
        
        EmailRow.defaultCellUpdate = { cell, row in
            cell.textField.font = gothamLight
            cell.textLabel?.font = gothamLight
        }
        
        TwitterRow.defaultCellUpdate = { cell, row in
            cell.textField.font = gothamLight
            cell.textLabel?.font = gothamLight
        }
        
        PasswordRow.defaultCellUpdate = { cell, row in
            cell.textField.font = gothamLight
            cell.textLabel?.font = gothamLight
        }
        
        PickerInlineRow<String>.defaultCellUpdate = { cell, row in
            cell.detailTextLabel?.font = gothamLight
            cell.textLabel?.font = gothamLight
        }
        
        
        let section = Section(){ section in
            
            section.footer = self.footerView()
            
            var header = HeaderFooterView<UIView>(.class)
            header.height = {40}
            header.onSetupView = { view, _ in
                view.backgroundColor = UIColor.FindaColors.White
                let title = UILabel(frame: CGRect(x:10,y: 5, width:self.view.frame.width - 10, height:40))
                
                title.text = "I'M A MODEL"
                title.font = UIFont(name: "Gotham-Medium", size: 16)
                view.addSubview(title)
                
                //                let description = UILabel(frame: CGRect(x:5,y: 40, width:self.view.frame.width, height:30))
                //                description.numberOfLines = 0
                //                description.text = "Please enter your measurements in centimeters."
                //                description.font = UIFont(name: "Gotham-Light", size: 13)
                //                view.addSubview(description)
                
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
                row.title = "Country"
                row.tag = "country"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            
            <<< EmailRow(){ row in
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
            
            
            <<< TwitterRow(){ row in
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
            }
            
            
            <<< DateInlineRow(){ row in
                row.title = "Date of Birth"
                row.tag = "dob"
                row.value = Date()
                
                var components = DateComponents()
                components.year = -18
                row.minimumDate = Calendar.current.date(byAdding: components, to: Date())
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
            
            <<< PickerInlineRow<String>() { row in
                row.title = "Gender"
                row.tag = "gender"
                
                row.options = ["Female", "Male"]
                row.value = "Female"
                row.add(rule: RuleRequired())
                row.add(rule: RuleMinLength(minLength: 1))
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
            
            
            <<< TextRow(){ row in
                row.title = "Referral Code"
                row.placeholder = "(optional)"
                row.tag = "referralCode"
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
    
    @objc func signUp(){
        
        
        guard let firstname: String = form.values()["firstName"] as? String else {
            self.validateRow(tag: "firstName")
            return
        }
        print(firstname)
        guard let lastname: String = form.values()["lastName"] as? String else {
            self.validateRow(tag: "lastName")
            return
        }
        print(lastname)
        guard let gender: String = form.values()["gender"] as? String else {
            self.validateRow(tag: "gender")
            return
        }
        print(gender)
        guard let country: String = form.values()["country"] as? String else {
            self.validateRow(tag: "country")
            return
        }
        print(country)
        guard let mail: String = form.values()["email"] as? String else {
            self.validateRow(tag: "email")
            return
        }
        print(mail)
        guard let instagram_username: String = form.values()["instagram"] as? String else {
            self.validateRow(tag: "instagram")
            return
        }
        print(instagram_username)
        guard let referral_code: String = form.values()["referralCode"] as? String else {
            self.validateRow(tag: "referralCode")
            return
        }
        print(referral_code)
        guard let password: String = form.values()["password"] as? String else {
            self.validateRow(tag: "password")
            return
        }
        print(password)
        guard let repeatPassword: String = form.values()["repeatPassword"] as? String else {
            self.validateRow(tag: "repeatPassword")
            return
        }
        print(repeatPassword)
        guard let dob: Date = form.values()["dob"] as? Date else {
            self.validateRow(tag: "dob")
            return
        }
        print(dob)
        
        if password != repeatPassword {
            print("Passwords don't match")
            return
        }
        
//        FindaAPISession(target: .registerModel(mail: mail, pass: password, firstname: firstname, lastname: lastname, gender: gender, country: country, instagram_username: instagram_username, referral_code: referral_code, dob: dob.timeIntervalSince1970)) { (response, result) in
//            if(response){
//
//            }
//        }
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
