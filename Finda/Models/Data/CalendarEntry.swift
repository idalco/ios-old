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
        self.scheduleId = data["scheduleId"].stringValue
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
        self.clientName = data["jobdetails"]["client_name"].stringValue
        self.clientCompany = data["jobdetails"]["company_name"].stringValue
        self.jobtypeDescription = data["jobdetails"]["jobtype_name"].stringValue
    }
    
    init(date: Double) {
        self.id = ""
        self.userid = 0
        self.calendarId = 0
        self.scheduleId = ""
        self.jobid = 0
        self.title = ""
        self.starttime = date
        self.endtime = date
        self.isAllDay = false
        self.location = ""
        self.isVisible = true
        self.isReadOnly = false
        self.isPrivate = false
        self.state = ""
        self.start = ""
        self.end = ""
        self.startDate = ""
        self.endDate = ""
        self.clientName = ""
        self.clientCompany = ""
        self.jobtypeDescription = ""
    }
    
    init(title: String, allday: Bool, starttime: Double, endtime: Double, location: String, state: String, scheduleid: String, userid: Int) {
        self.id = ""
        self.userid = userid
        self.calendarId = 0
        self.scheduleId = scheduleid
        self.jobid = 0
        self.title = title
        self.starttime = starttime
        self.endtime = endtime
        self.isAllDay = allday
        self.location = location
        self.isVisible = true
        self.isReadOnly = false
        self.isPrivate = false
        self.state = state
        self.start = ""
        self.end = ""
        self.startDate = ""
        self.endDate = ""
        self.clientName = ""
        self.clientCompany = ""
        self.jobtypeDescription = ""
    }
    
}
