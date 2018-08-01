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
    
    @IBOutlet var closeNumberLabel: UILabel!
    @IBOutlet var openNumberLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    
//    var number: Int = 0 {
//        didSet {
//            closeNumberLabel.text = String(number)
//            openNumberLabel.text = String(number)
//        }
//    }
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        headerLabel.underline()
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
