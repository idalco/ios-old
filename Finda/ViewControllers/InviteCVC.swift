//
//  InviteCVC.swift
//  Finda
//
//  Created by Peter Lloyd on 26/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import UIKit

class InviteCVC: ImageCVC {
    
    @IBOutlet weak var referralAvatar: UIImageView!
    @IBOutlet weak var referralStatus: UIImageView!
    @IBOutlet weak var referralName: UILabel!
    
    override func awakeFromNib() {
        layoutIfNeeded()
    }
}
