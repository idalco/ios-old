//
//  DateExtensions.swift
//  Finda
//
//  Created by Peter Lloyd on 01/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation

extension Date {
    func displayDate(timeInterval: Int, format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
