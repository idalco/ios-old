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


class DateCell: JTACDayCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var selectedView: UIView!
    @IBOutlet var dotView: UIView!
    @IBOutlet var userDot: UIView!
    
    var calendarEntry: CalendarEntry = CalendarEntry(data: [])
    var hasData: Bool = false
}
