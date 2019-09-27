//
//  NotificationCell.swift
//  Finda
//
//  Created by Peter Lloyd on 06/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UITextView!
    @IBOutlet weak var messageAvatar: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageImageWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        contentView.backgroundColor = UIColor.FindaColors.Purple.lighter(by: 80)
        contentView.layer.cornerRadius  = 2
        contentView.layer.masksToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
