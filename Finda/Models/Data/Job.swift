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

extension Job: Hashable {
    static func == (lhs: Job, rhs: Job) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var hashValue: Int {
        return clientUid.hashValue ^ projectTid.hashValue ^ created.hashValue ^ modified.hashValue ^ jobStatus.hashValue ^ name.hashValue ^ offeredRate.hashValue ^ negotiatedRate.hashValue ^ agreedRate.hashValue ^ timeUnits.hashValue ^ unitsType.hashValue ^ startdate.hashValue ^ starttime.hashValue ^ description.hashValue ^ clientJobCompleted.hashValue ^ location.hashValue ^ invoiceID.hashValue ^ invoicePaid.hashValue ^ callsheet.hashValue ^ jobid.hashValue ^ modelDesiredRate.hashValue ^ clientOfferedRate.hashValue ^ status.hashValue ^ rating.hashValue ^ modelNotes.hashValue ^ jobtype.hashValue ^ companyName.hashValue ^ companyWebsite.hashValue
    }
}
//
//extension Job: Equatable {
//    static func == (lhs: Job, rhs: Job) -> Bool {
//        print(lhs.clientUid == rhs.clientUid)
//        return lhs.clientUid == rhs.clientUid &&
//            lhs.projectTid == rhs.projectTid &&
//            lhs.created == rhs.created &&
//            lhs.modified == rhs.modified &&
//            lhs.jobStatus == rhs.jobStatus &&
//            lhs.name == rhs.name &&
//            lhs.offeredRate == rhs.offeredRate &&
//            lhs.negotiatedRate == rhs.negotiatedRate &&
//            lhs.agreedRate == rhs.agreedRate &&
//            lhs.timeUnits == rhs.timeUnits &&
//            lhs.unitsType == rhs.unitsType &&
//            lhs.startdate == rhs.startdate &&
//            lhs.starttime == rhs.starttime &&
//            lhs.description == rhs.description &&
//            lhs.clientJobCompleted == rhs.clientJobCompleted &&
//            lhs.location == rhs.location &&
//            lhs.invoiceID == rhs.invoiceID &&
//            lhs.invoicePaid == rhs.invoicePaid &&
//            lhs.callsheet == rhs.callsheet &&
//            lhs.jobid == rhs.jobid &&
//            lhs.modelDesiredRate == rhs.modelDesiredRate &&
//            lhs.clientOfferedRate == rhs.clientOfferedRate &&
//            lhs.status == rhs.status &&
//            lhs.rating == rhs.rating &&
//            lhs.modelNotes == rhs.modelNotes &&
//            lhs.jobtype == rhs.jobtype &&
//            lhs.companyName == rhs.companyName &&
//            lhs.companyWebsite == rhs.companyWebsite
//
//
//    }
//}
