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
    
    let nationality = [
        "United Kingdom",
        "United States",
        "Afghanistan",
        "Albania",
        "Algeria",
        "Andorra",
        "Angola",
        "Antigua and Barbuda",
        "Argentina",
        "Armenia",
        "Australia",
        "Austria",
        "Azerbaijan",
        "Bahamas",
        "Bahrain",
        "Bangladesh",
        "Barbados",
        "Belarus",
        "Belgium",
        "Belize",
        "Benin",
        "Bhutan",
        "Bolivia",
        "Bosnia and Herzegovina",
        "Botswana",
        "Brazil",
        "Brunei Darussalam",
        "Bulgaria",
        "Burkina Faso",
        "Burundi",
        "Cambodia",
        "Cameroon",
        "Canada",
        "Cape Verde",
        "Central African Republic",
        "Chad",
        "Chile",
        "China",
        "Colombia",
        "Comoros",
        "Congo (Republic of the)",
        "Costa Rica",
        "Côte d’Ivoire",
        "Croatia",
        "Cuba",
        "Cyprus",
        "Czech Republic",
        "Democratic People’s Republic of Korea",
        "Democratic Republic of the Congo",
        "Denmark",
        "Djibouti",
        "Dominica",
        "Dominican Republic",
        "Ecuador",
        "Egypt",
        "El Salvador",
        "Equatorial Guinea",
        "Eritrea",
        "Estonia",
        "Ethiopia",
        "Fiji",
        "Finland",
        "France",
        "Gabon",
        "Gambia",
        "Georgia",
        "Germany",
        "Ghana",
        "Greece",
        "Grenada",
        "Guatemala",
        "Guinea",
        "Guinea-Bissau",
        "Guyana",
        "Haiti",
        "Honduras",
        "Hungary",
        "Iceland",
        "India",
        "Indonesia",
        "International School (UK)",
        "Iran",
        "Iraq",
        "Ireland",
        "Israel",
        "Italy",
        "Jamaica",
        "Japan",
        "Jordan",
        "Kazakhstan",
        "Kenya",
        "Kiribati",
        "Kuwait",
        "Kyrgyzstan",
        "Lao People’s Democratic Republic",
        "Latvia",
        "Lebanon",
        "Lesotho",
        "Liberia",
        "Libya",
        "Liechtenstein",
        "Lithuania",
        "Luxembourg",
        "Madagascar",
        "Malawi",
        "Malaysia",
        "Maldives",
        "Mali",
        "Malta",
        "Marshall Islands",
        "Mauritania",
        "Mauritius",
        "Mexico",
        "Micronesia (Federated States of)",
        "Monaco",
        "Mongolia",
        "Montenegro",
        "Morocco",
        "Mozambique",
        "Myanmar",
        "Namibia",
        "Nauru",
        "Nepal",
        "Netherlands",
        "New Zealand",
        "Nicaragua",
        "Niger",
        "Nigeria",
        "Norway",
        "Oman",
        "Pakistan",
        "Palau",
        "Panama",
        "Papua New Guinea",
        "Paraguay",
        "Peru",
        "Philippines",
        "Poland",
        "Portugal",
        "Qatar",
        "Republic of Korea",
        "Republic of Moldova",
        "Romania",
        "Russian Federation",
        "Rwanda",
        "Saint Kitts and Nevis",
        "Saint Lucia",
        "vaint Vincent and the Grenadines",
        "Samoa",
        "San Marino",
        "Sao Tome and Principe",
        "Saudi Arabia",
        "Senegal",
        "Serbia",
        "Seychelles",
        "Sierra Leone",
        "Singapore",
        "Slovakia",
        "Slovenia",
        "Solomon Islands",
        "Somalia",
        "South Africa",
        "South Sudan",
        "Spain",
        "Sri Lanka",
        "Sudan",
        "Suriname",
        "Swaziland",
        "Switzerland",
        "Sweden",
        "Syria",
        "Tajikistan",
        "Thailand",
        "The former Yugoslav Republic of Macedonia",
        "Timor Leste",
        "Togo",
        "Tonga",
        "Trinidad and Tobago",
        "Tunisia",
        "Turkey",
        "Turkmenistan",
        "Tuvalu",
        "Uganda",
        "Ukraine",
        "United Arab Emirates",
        "United Kingdom",
        "United of Republic of Tanzania",
        "United States",
        "Uruguay",
        "Uzbekistan",
        "Vanuatu",
        "Venezuela",
        "Vietnam",
        "Yemen",
        "Zambia",
        "Zimbabwe"
    ]
    
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
            }   <<< TextRow(){ row in
                row.title = "First name"
                row.value = modelManager.firstName()
       
                
            }
            
            <<< TextRow(){ row in
                row.title = "Last name"
                row.value = modelManager.lastName()
            }
            
            <<< DateInlineRow(){ row in
                row.title = "Date of Birth"
                
                var components = DateComponents()
                components.year = -18
                row.minimumDate = Calendar.current.date(byAdding: components, to: Date())
                
                
                let data = modelManager.dateOfBirth()
                if data != -1 {
                    row.value = Date(timeIntervalSince1970: TimeInterval(data))
                }
                
                
            }
            
            <<< EmailRow(){ row in
                row.title = "Email address"
                row.value = modelManager.email()
            }
            
            
            <<< PickerInlineRow<String>() { row in
                row.title = "Gender"
                
                row.options = ["Female", "Male"]
                row.value = modelManager.gender().capitalizingFirstLetter()
            }
            
            
            <<< PickerInlineRow<String>() { row in
                row.title = "Nationality"
                
                row.options = self.nationality
                let nationality = modelManager.nationality()
                row.value = nationality
                if nationality != "" {
                    row.disabled = true
                }
            }
            
            <<< PickerInlineRow<String>() { row in
                row.title = "Country of residence"
                
                row.options = self.nationality
                let residenceCountry = modelManager.residenceCountry()
                row.value = residenceCountry
    
                if residenceCountry != "" {
                    row.disabled = true
                }
            }
            
            <<< TextRow(){ row in
                row.title = "Instagram Username"
                row.value = modelManager.instagramUserName()
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
                
        }
        
        form +++ section
        
        PickerDelegate.addPickerData(term: .Ethnicity, rowTitle: "Ethnicity", coreData: modelManager.ethnicity()) { (response, result) in
            if response {
                section.insert(result, at: 5)
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
