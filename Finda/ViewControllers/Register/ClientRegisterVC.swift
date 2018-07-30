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
            }
            
            <<< TextRow(){ row in
                row.title = "Last Name"
            }
            
            <<< TextRow(){ row in
                row.title = "Company Name"
            }
            
            <<< EmailRow(){ row in
                row.title = "Company Email"
            }
            
            <<< URLRow(){ row in
                row.title = "Company Website"
            }
            
            <<< TextRow(){ row in
                row.title = "Position"
            }
            
            <<< PhoneRow(){ row in
                row.title = "Telephone"
            }
            
            <<< PasswordRow(){ row in
                row.title = "Password"
            }
            
            <<< PasswordRow(){ row in
                row.title = "Repeat Password"
        }
        
        
        form +++ section
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    @objc func signUp(){
        print("Client")
    }
    
    func footerView() -> HeaderFooterView<UIView> {
        
        var footer = HeaderFooterView<UIView>(.class)
        footer.height = {200}
        footer.onSetupView = { view, _ in
            
  
            view.addSubview(RegisterFooter.legalFooter(width: self.view.frame.width))
            
            let button = DCRoundedButton(frame: CGRect(x: (self.view.frame.width / 2) - (215 / 2), y: 130, width: 215, height: 45))
            button.setTitle("SIGN UP", for: .normal)
            
            button.titleLabel?.font = UIFont(name: "Gotham-Bold", size: 16)
            
            button.addTarget(self, action:#selector(self.signUp), for: UIControlEvents.touchUpInside)
            
            button.normalBackgroundColor = UIColor.FindaColors.Purple
            button.normalBorderColor = UIColor.FindaColors.Purple
            button.normalTextColor = UIColor.FindaColors.White
            button.cornerRadius = 5
            
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
