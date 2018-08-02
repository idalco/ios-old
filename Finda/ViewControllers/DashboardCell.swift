//
//  DemoCell.swift
//  Finda
//
//  Created by Peter Lloyd on 31/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit
import FoldingCell

class DashboardCell: FoldingCell {
    

    @IBOutlet weak var openHeaderLabel: UILabel!
    @IBOutlet weak var openDescriptionLabel: UILabel!
    @IBOutlet weak var openCompanyLabel: UILabel!
    @IBOutlet weak var openJobTypeLabel: UILabel!
    @IBOutlet weak var openLocationLabel: UILabel!
    @IBOutlet weak var openDateLabel: UILabel!
    @IBOutlet weak var openLengthLabel: UILabel!
    @IBOutlet weak var openInformationLabel: UILabel!
    
    
    @IBOutlet weak var closedHeaderLabel: UILabel!
    @IBOutlet weak var closedDescriptionLabel: UILabel!
    @IBOutlet weak var closedCompanyLabel: UILabel!
    @IBOutlet weak var closedJobTypeLabel: UILabel!
    @IBOutlet weak var closedLocationLabel: UILabel!
    @IBOutlet weak var closedDateLabel: UILabel!
    @IBOutlet weak var closedLengthLabel: UILabel!
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        openHeaderLabel.underline()
        closedHeaderLabel.underline()
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}

// MARK: - Actions ⚡️

extension DashboardCell {
    
    @IBAction func buttonHandler(_: AnyObject) {
        print("tap")
    }
}
