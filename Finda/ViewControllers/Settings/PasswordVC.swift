//
//  PasswordVC.swift
//  Finda
//
//  Created by Peter Lloyd on 03/09/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import Eureka

class PasswordVC: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateRows()
        
        form +++ Section(){ section in
            var header = HeaderFooterView<UIView>(.class)
            header.height = {70}
            header.onSetupView = { view, _ in
                view.backgroundColor = UIColor.FindaColors.White
                let title = UILabel(frame: CGRect(x:10,y: 5, width:self.view.frame.width, height:40))
                
                title.text = "Password Management"
                title.font = UIFont(name: "Gotham-Medium", size: 17)
                view.addSubview(title)
                
                let description = UILabel(frame: CGRect(x:10,y: 40, width:self.view.frame.width, height:20))
                description.numberOfLines = 0
//                description.text = "Set your email contact preferences."
                description.font = UIFont(name: "Gotham-Light", size: 13)
                view.addSubview(description)
                
            }
            section.header = header
            }
            
            <<< TextRow(){ row in
                row.title = "Old Password"
                row.tag = "old password"
                
            }

            
            <<< TextRow(){ row in
                row.title = "New Password"
                row.tag = "new password"
                
            }

            
            <<< TextRow(){ row in
                row.title = "Repeat New Password"
                row.tag = "repeat new password"
                
            }


        // Do any additional setup after loading the view.
    }
    
    private func updateRows(){
        LoginManager.getDetails { (response, result) in
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
