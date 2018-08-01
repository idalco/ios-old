//
//  Job.swift
//  Finda
//
//  Created by Peter Lloyd on 01/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

class Job {
    
    var companyWebsite: String
    var modelCount: Int
    var modelId: Int
    var statusText: String
    var modelDesiredRate: Double
    var invoiceId: Int
    var callSheet: String
    var clientJobCompleted: Bool
    var clientNotes: String
    var agreedRate: Double
    var modelUid: Int
    var modified: Int
    var clientOfferedRate: Double
    var id: Int
    var modelNotes: String
    var startDate: Int
    var companyName: String
    var clientJobPaid: Bool
    var jobId: Int
    var projectTid: Int
    var jobStatus: Int
    var name: String
    var negotiatedRate: Double
    var description: String
    var jobType: String
    var timeUnits: Int
    var clientUid: Int
    var rating: Double
    var jobStatusText: String
    var status: Int
    var location: String
    var created: Int
    var offeredRate: Double
    var startTime: Int
    var unitsType: String
    var invoicePaid: Bool
    
    init(data: JSON){
        
        self.companyWebsite = data["company_website"].stringValue
        self.modelCount = data["modelcount"].intValue
        self.modelId = data["modelid"].intValue
        self.statusText = data["status_text"].stringValue
        self.modelDesiredRate = data["model_desired_rate"].doubleValue
        self.invoiceId = data["invoice_id"].intValue
        self.callSheet = data["callsheet"].stringValue
        self.clientJobCompleted = data["client_job_completed"].boolValue
        self.clientNotes = data["client_notes"].stringValue
        self.agreedRate = data["agreed_rate"].doubleValue
        self.modelUid = data["model_uid"].intValue
        self.modified = data["modified"].intValue
        self.clientOfferedRate = data["client_offered_rate"].doubleValue
        self.id = data["id"].intValue
        self.modelNotes = data["model_notes"].stringValue
        self.startDate = data["startdate"].intValue
        self.companyName = data["company_name"].stringValue
        self.clientJobPaid = data["client_job_paid"].boolValue
        self.jobId = data["jobid"].intValue
        self.projectTid = data["project_tid"].intValue
        self.jobStatus = data["job_status"].intValue
        self.name = data["name"].stringValue
        self.negotiatedRate = data["negotiated_rate"].doubleValue
        self.description = data["description"].stringValue
        self.jobType = data["jobtype"].stringValue
        self.timeUnits = data["time_units"].intValue
        self.clientUid = data["client_uid"].intValue
        self.rating = data["rating"].doubleValue
        self.jobStatusText = data["job_status_text"].stringValue
        self.status = data["status"].intValue
        self.location = data["location"].stringValue
        self.created = data["created"].intValue
        self.offeredRate = data["offered_rate"].doubleValue
        self.startTime = data["starttime"].intValue
        self.unitsType = data["units_type"].stringValue
        self.invoicePaid = data["invoice_paid"].boolValue
        
    }
}
