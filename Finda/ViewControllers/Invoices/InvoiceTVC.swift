//
//  InvoiceTVC.swift
//  Finda
//
//  Created by Peter Lloyd on 02/09/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import UIKit

class InvoiceTVC: UITableViewCell {
    
    @IBOutlet weak var invoiceNumber: UILabel!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var paidOn: UILabel!
    @IBOutlet weak var paid: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
