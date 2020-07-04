//
//  InviteVC.swift
//  Finda
//
//  Created by Peter Lloyd on 20/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import DCKit

class InviteInformationVC: UIViewController {
    
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var topInfoLabel: UILabel!
    @IBOutlet weak var bottomInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(InviteInformationVC.backButtonTapped))
        backButton.addGestureRecognizer(tapRec)
        backButton.isUserInteractionEnabled = true
        
        
        
        let line1 = NSMutableAttributedString(string: "We have signed up large ecommerce clients that make ")
        let line2 = NSMutableAttributedString(string: "hundreds of bookings monthly")
        let line3 = NSMutableAttributedString(string: ". They sign up with us because they need a new, efficient and fair way to work with models like you.\n\n")

        let line4 = NSMutableAttributedString(string: "The clients will begin using the Idal booking platform consistently if we can offer them much more available talent to choose from, this is why we need your help!")

        let line5 = NSMutableAttributedString(string: "You only receive points for ")
        let line6 = NSMutableAttributedString(string: "verified")
        let line7 = NSMutableAttributedString(string: " professional models! They will need to complete their profiles and be accepted by our verification team.")
        
        if let mainfont = UIFont(name: "Montserrat-Regular", size: 14) {
            line1.addAttribute(.font, value: mainfont, range: NSMakeRange(0, line1.length))
            line3.addAttribute(.font, value: mainfont, range: NSMakeRange(0, line3.length))
            line4.addAttribute(.font, value: mainfont, range: NSMakeRange(0, line4.length))
            line5.addAttribute(.font, value: mainfont, range: NSMakeRange(0, line5.length))
            line7.addAttribute(.font, value: mainfont, range: NSMakeRange(0, line7.length))
        }
        
        if let boldfont = UIFont(name: "Montserrat-Bold", size: 14) {
            line2.addAttribute(.font, value: boldfont, range: NSMakeRange(0, line2.length))
            line6.addAttribute(.font, value: boldfont, range: NSMakeRange(0, line6.length))
        }
        
        line1.append(line2)
        line1.append(line3)
        line1.append(line4)
        
        line5.append(line6)
        line5.append(line7)
        
        let baseParagraphStyle = NSMutableParagraphStyle()
        baseParagraphStyle.alignment = .center
        baseParagraphStyle.lineSpacing = 4
        baseParagraphStyle.paragraphSpacing = 0
        
        line1.addAttributes([.paragraphStyle: baseParagraphStyle], range: NSRange(location: 0, length: line1.length))
        
        line5.addAttributes([.paragraphStyle: baseParagraphStyle], range: NSRange(location: 0, length: line5.length))
        
        topInfoLabel.attributedText = line1
        bottomInfoLabel.attributedText = line5
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    @objc private func backButtonTapped(sender: UIImageView) {
        self.dismiss(animated: true)
    }
    
}

