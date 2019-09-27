//
//  ChatVCCell.swift
//  Finda
//
//  Created by cro on 12/09/2019.
//  Copyright © 2019 Finda Ltd. All rights reserved.
//

import UIKit
import DCKit

class TableChatVCCell: UITableViewCell {
    
    @IBOutlet weak var recipientAvatarimage: UIImageView!
    @IBOutlet weak var senderAvatarImage: UIImageView!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var dateStamp: UILabel!

    @IBOutlet weak var imageHolder: UIImageView!
    @IBOutlet weak var imageHolderHeight: NSLayoutConstraint!

    @IBOutlet weak var recipientChatArrow: UIImageView!
    @IBOutlet weak var senderChatArrow: UIImageView!
    @IBOutlet weak var messageContentBox: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius  = 2
        contentView.layer.masksToBounds = true
//        layoutIfNeeded()
    }
    
}


