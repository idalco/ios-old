//
//  CalendarCell.swift
//  Finda
//
//  Created by cro on 22/05/2019.
//  Copyright © 2019 Finda Ltd. All rights reserved.
//

import Foundation
import JTAppleCalendar
import UIKit


class TodayTableCell: UITableViewCell {

    @IBOutlet var todayEntryTitle: UILabel!
    @IBOutlet var todayEntryDates: UILabel!
    @IBOutlet var todayEntryBrandname: UILabel!
    
    var dayEntry: CalendarEntry = CalendarEntry(data: [])
    
}
