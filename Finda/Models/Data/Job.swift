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
    let name, header: String
    let offeredRate, negotiatedRate, agreedRate: Int
    let timeUnits: Float
    let unitsType: String
    let startdate, starttime: Int
    let description: String
    let clientJobCompleted: Bool
    let location: String
    let invoiceID: Int
    let invoicePaid: Bool
    let callsheet: String
    let jobid: Int
    let modelDesiredRate, clientOfferedRate: Int
    let status: Int
    let rating: Double
    let modelNotes, jobtype, companyName, companyWebsite, avatar: String
    
//    let advanced_model_to_bring, advanced_transport_methods, advanced_model_expenses, advanced_model_meeting_point: String
//    let advanced_makeup_provided, advanced_contact_number: String
    let advanced, contact_number: String
    
    let usage_jobid, usage_uk, usage_europe, usage_international, usage_brochure: Int
    let usage_posters, usage_advertising, usage_billboards, usage_digitalads: Int
    let usage_socialmedia, usage_companywebsite, usage_tv: Int
    
    init(data: JSON) {
        self.clientUid = data["client_uid"].intValue
        self.projectTid = data["project_tid"].intValue
        self.created = data["created"].intValue
        self.modified = data["modified"].intValue
        self.jobStatus = data["job_status"].intValue
        self.name = data["name"].stringValue
        self.offeredRate = data["offered_rate"].intValue
        self.negotiatedRate = data["negotiated_rate"].intValue
        self.agreedRate = data["agreed_rate"].intValue
        self.timeUnits = data["time_units"].floatValue
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
        self.modelDesiredRate = data["model_desired_rate"].intValue
        self.clientOfferedRate = data["client_offered_rate"].intValue
        self.status = data["status"].intValue
        self.rating = data["rating"].doubleValue
        self.modelNotes = data["model_notes"].stringValue
        self.jobtype = data["jobtype"].stringValue
        self.companyName = data["company_name"].stringValue
        self.companyWebsite = data["company_website"].stringValue
        self.header = data["status_text"].stringValue
        
//        self.advanced_model_to_bring = data["advanced_model_to_bring"].stringValue
//        self.advanced_transport_methods = data["advanced_transport_methods"].stringValue
//        self.advanced_model_expenses = data["advanced_model_expenses"].stringValue
//        self.advanced_model_meeting_point = data["advanced_model_meeting_point"].stringValue
//        self.advanced_makeup_provided = data["advanced_makeup_provided"].stringValue
        self.advanced = data["advanced"].stringValue
        self.contact_number = data["contact_number"].stringValue
        self.usage_jobid = data["usage_jobid"].intValue
        self.usage_uk = data["usage_uk"].intValue
        self.usage_europe = data["usage_europe"].intValue
        self.usage_international = data["usage_international"].intValue
        self.usage_brochure = data["usage_brochure"].intValue
        self.usage_posters = data["usage_posters"].intValue
        self.usage_advertising = data["usage_advertising"].intValue
        self.usage_billboards = data["usage_billboards"].intValue
        self.usage_digitalads = data["usage_digitalads"].intValue
        self.usage_socialmedia = data["usage_socialmedia"].intValue
        self.usage_companywebsite = data["usage_companywebsite"].intValue
        self.usage_tv = data["usage_tv"].intValue
        self.avatar = data["avatar"].stringValue
    }
    
}

extension Job: Hashable {
    static func == (lhs: Job, rhs: Job) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var hashValue: Int {
        return clientUid.hashValue ^ projectTid.hashValue ^ created.hashValue ^ modified.hashValue ^ jobStatus.hashValue ^ name.hashValue ^ offeredRate.hashValue ^ negotiatedRate.hashValue ^ agreedRate.hashValue ^ timeUnits.hashValue ^ unitsType.hashValue ^ startdate.hashValue ^ starttime.hashValue ^ description.hashValue ^ clientJobCompleted.hashValue ^ location.hashValue ^ invoiceID.hashValue ^ invoicePaid.hashValue ^ callsheet.hashValue ^ jobid.hashValue ^ modelDesiredRate.hashValue ^ clientOfferedRate.hashValue ^ status.hashValue ^ rating.hashValue ^ modelNotes.hashValue ^ jobtype.hashValue ^ companyName.hashValue ^ companyWebsite.hashValue ^ avatar.hashValue
    }
}

