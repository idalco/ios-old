//
//  Job.swift
//  Finda
//
//  Created by Peter Lloyd on 01/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Job {
    let clientUid, projectTid, created, modified: Int
    let jobStatus: Int
    let name: String
    let offeredRate, negotiatedRate, agreedRate: Double
    let timeUnits: Int
    let unitsType: String
    let startdate, starttime: Int
    let description: String
    let clientJobCompleted: Bool
    let location: String
    let invoiceID: Int
    let invoicePaid: Bool
    let callsheet: String
    let jobid: Int
    let modelDesiredRate, clientOfferedRate: Double
    let status: Int
    let rating: Double
    let modelNotes, jobtype, companyName, companyWebsite: String
    
    init(data: JSON) {
        self.clientUid = data["client_uid"].intValue
        self.projectTid = data["project_tid"].intValue
        self.created = data["created"].intValue
        self.modified = data["modified"].intValue
        self.jobStatus = data["job_status"].intValue
        self.name = data["name"].stringValue
        self.offeredRate = data["offered_rate"].doubleValue
        self.negotiatedRate = data["negotiated_rate"].doubleValue
        self.agreedRate = data["agreed_rate"].doubleValue
        self.timeUnits = data["time_units"].intValue
        self.unitsType = data["units_type"].stringValue
        self.startdate = data["startdate"].intValue
        self.starttime = data["starttime"].intValue
        self.description = data["description"].stringValue
        self.clientJobCompleted = data["client_job_completed"].boolValue
        self.location = data["location"].stringValue
        self.invoiceID = data["invoice_id"].intValue
        self.invoicePaid = data["invoice_paid"].boolValue
        self.callsheet = data["callsheet"].stringValue
        self.jobid = data["jobid"].intValue
        self.modelDesiredRate = data["model_desired_rate"].doubleValue
        self.clientOfferedRate = data["client_offered_rate"].doubleValue
        self.status = data["status"].intValue
        self.rating = data["rating"].doubleValue
        self.modelNotes = data["model_notes"].stringValue
        self.jobtype = data["jobtype"].stringValue
        self.companyName = data["company_name"].stringValue
        self.companyWebsite = data["company_website"].stringValue
    }
}

