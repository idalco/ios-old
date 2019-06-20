//
//  InvoiceManager.swift
//  Finda
//
//  Created by Peter Lloyd on 02/09/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON


class CalendarEntryManager {
    
    static func getCalendarEntries(completion: @escaping (_ response: Bool, _ result: JSON, _ CalendarEntry: [CalendarEntry]) -> ()){
        
        FindaAPISession(target: .getCalendar) { (response, result) in
            if response {
                var entriesArray: [CalendarEntry] = []
                for entry in result["userdata"].arrayValue {
                    let calendarEntry = CalendarEntry(data: entry)
                    entriesArray.append(calendarEntry)
                }
                completion(response, result, entriesArray)
                
            } else {
                completion(false, result, [])
            }
        }
        
    }
    
    static func getCalendarEntriesForDate(date: Double, completion: @escaping (_ response: Bool, _ result: JSON, _ CalendarEntry: [CalendarEntry]) -> ()){
        
        FindaAPISession(target: .getCalendarEntriesForDate(date: date)) { (response, result) in
            if response {
                var entriesArray: [CalendarEntry] = []
                for entry in result["userdata"].arrayValue {
                    let calendarEntry = CalendarEntry(data: entry)
                    entriesArray.append(calendarEntry)
                }
                completion(response, result, entriesArray)
                
            } else {
                completion(false, result, [])
            }
        }
        
    }
    
    static func deleteCalendarEntry(scheduleId: String, completion: @escaping (_ response: Bool, _ result: JSON) -> ()) {
    
        FindaAPISession(target: .deleteCalendarEntry(entry: scheduleId)) { (response, result) in
            completion(response, result)
        }
    }
    
}

