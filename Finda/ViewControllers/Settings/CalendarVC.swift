//
//  CalendarVC.swift
//  Finda
//
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
//import Eureka
import SVProgressHUD
import DCKit

class CalendarVC: UIViewController {
    
 
    @IBOutlet weak var availabilityToggle: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let modelManager = ModelManager()
        
        let availability = modelManager.available()
        
        if availability  == true {
            availabilityToggle.isOn = true
        } else {
            availabilityToggle.isOn = false
        }
        
        availabilityToggle.addTarget(self, action: #selector(toggleAvailability(sender:)), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func toggleAvailability(sender: UISwitch) {
        var available = 0
        if availabilityToggle.isOn {
            available = 1
        }
        
        FindaAPISession(target: .updateAvailability(availability: available)) { (response, result) in
            if response {
            } else {
                SVProgressHUD.setBackgroundColor(UIColor.FindaColours.Blue)
                SVProgressHUD.setForegroundColor(UIColor.FindaColours.White)
                SVProgressHUD.showError(withStatus: "There was a problem saving your availability")
            }
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
