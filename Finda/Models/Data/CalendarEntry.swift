//
//  Photo.swift
//  Finda
//
//  Created by Peter Lloyd on 14/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

class CalendarEntry {
    
    let id: String //"af1ef081-8107-52c0-a9a5-06b2d3ced223",
    let userid: Int // "1",
    let calendarId: Int // "1",
    let scheduleId: String //"af1ef081-8107-52c0-a9a5-06b2d3ced223",
    let jobid: Int // "0",
    let title: String // "Hello again!",
    let starttime: Double! // "1528066800",
    let endtime: Double! // "1528498799",
    let isAllDay: Bool // true,
    let location: String // "",
    let isVisible: Bool // "1",
    let isReadOnly: Bool // false,
    let isPrivate: Bool // "0",
    let state: String // "Busy",
    let start: String // "2018-06-03T23:00:00+00:00",
    let end: String // "2018-06-08T22:59:59+00:00",
    let startDate: String
    let endDate: String
    
    // extension for job details
    let clientName: String
    let clientCompany: String
    let jobtypeDescription: String
    
    init(data: JSON) {
        self.id = data["id"].stringValue
        self.userid = data["userid"].intValue
        self.calendarId = data["calendarId"].intValue
        self.scheduleId = data["schedulId"].stringValue
        self.jobid = data["jobid"].intValue
        self.title = data["title"].stringValue
        self.starttime = data["starttime"].doubleValue
        self.endtime = data["endtime"].doubleValue
        self.isAllDay = data["isAllDay"].boolValue
        self.location = data["location"].stringValue
        self.isVisible = data["isVisible"].boolValue
        self.isReadOnly = data["isReadOnly"].boolValue
        self.isPrivate = data["isPrivate"].boolValue
        self.state = data["state"].stringValue
        self.start = data["start"].stringValue
        self.end = data["end"].stringValue
        self.startDate = data["startDate"].stringValue
        self.endDate = data["endDate"].stringValue
        self.clientName = data["client_name"].stringValue
        self.clientCompany = data["company_name"].stringValue
        self.jobtypeDescription = data["jobtype_name"].stringValue
    }
    
}
