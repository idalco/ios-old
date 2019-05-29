//
//  JobCardViewCVC.swift
//  Finda
//
//  Created by cro on 13/03/2019.
//  Copyright © 2019 Finda Ltd. All rights reserved.
//

import Foundation
import UIKit
import DCKit

class CalendarEntryCardViewCVC: UICollectionViewCell {
 
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellJobtime: UILabel!
    @IBOutlet weak var cellLocation: UILabel!
    @IBOutlet weak var cellJobstatus: UILabel!
    @IBOutlet weak var cellCustomer: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
    }
    
}
