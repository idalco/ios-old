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

class JobCardViewCVC: UICollectionViewCell {
 
    @IBOutlet weak var jobStatus: UILabel!
    @IBOutlet weak var jobType: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var jobDates: UILabel!
    @IBOutlet weak var jobTime: UILabel!
    @IBOutlet weak var jobStatusColour: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true

        layoutIfNeeded()
    }
    
}
