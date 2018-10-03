//
//  RegistrationNavBar.swift
//  Finda
//
//  Created by Peter Lloyd on 11/09/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit

class RegistrationNavBar: UINavigationBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.tintColor = UIColor.FindaColours.Black
        self.layoutIfNeeded()
    }
    
}
