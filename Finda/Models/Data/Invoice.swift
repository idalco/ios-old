//
//  Invoice.swift
//  Finda
//
//  Created by Peter Lloyd on 02/09/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

class Invoice {
    
    
    let id, clientid, modelid, jobid, date_created, due_date, date_paid, status : Int
    let value: Float
    let description, invoicetype, transaction_id, symbol, jobname : String
    
    
    init(data: JSON) {
        self.id = data["id"].intValue
        self.clientid = data["clientid"].intValue
        self.modelid = data["modelid"].intValue
        self.jobid = data["jobid"].intValue
        self.date_created = data["date_created"].intValue
        self.due_date = data["due_date"].intValue
        self.date_paid = data["date_paid"].intValue
        self.status = data["status"].intValue
        self.transaction_id = data["transaction_id"].stringValue
        self.value = data["value"].floatValue
        self.description = data["jobdescription"].stringValue
        self.invoicetype = data["invoicetype"].stringValue
        self.symbol = data["symbol"].stringValue
        self.jobname = data["jobname"].stringValue
    }
}
