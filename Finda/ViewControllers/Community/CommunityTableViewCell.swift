//
//  CommunityTableViewCell.swift
//  Finda
//
//  Created by Peter Lloyd on 06/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit

class CommunityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var communityItemTitle: UILabel!
    @IBOutlet weak var communityItemDate: UILabel!
    @IBOutlet weak var communityItemContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius  = 0
        contentView.layer.masksToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
