//
//  PortfolioCVC.swift
//  Finda
//
//  Created by Peter Lloyd on 26/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import UIKit

class PortfolioCVC: ImageCVC {
    @IBOutlet weak var leadImageButton: UIButton!
    
    override func awakeFromNib() {
//        leadImageButton.backgroundColor = leadImageButton.backgroundColor?.fade(alpha: 0.75)
        leadImageButton.setFAIcon(icon: .FACheck, forState: .normal)
//        deleteButton.backgroundColor = deleteButton.backgroundColor?.fade(alpha: 0.75)
        layoutIfNeeded()
    }
}
