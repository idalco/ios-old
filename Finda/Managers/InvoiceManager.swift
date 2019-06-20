//
//  InvoiceManager.swift
//  Finda
//
//  Created by Peter Lloyd on 02/09/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON


class InvoiceManager {
    
    static func getInvoice(completion: @escaping (_ response: Bool, _ result: JSON, _ Invoice: [Invoice]) -> ()){
        FindaAPISession(target: .getModelInvoices) { (response, result) in
            if(response){
                var invoicesArray: [Invoice] = []
                for invoice in result["userdata"].arrayValue {
                    invoicesArray.append(Invoice(data: invoice))
                }
                
                completion(response, result, invoicesArray)
                return
            }
            completion(false, result, [])
        }
    }
    
}

