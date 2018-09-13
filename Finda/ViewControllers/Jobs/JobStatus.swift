//
//  JobStatus.swift
//  Finda
//
//  Created by Peter Lloyd on 04/09/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation

//// Status
//enum JobStatus: Int {
//
//
//
//    case Offered = 1
//    // Accepted
//    // status 2 and start date >= current date
//    case Accepted = 2
//    // Unfinalised
//    // status 2 and start date < current date
//    case Unfinalised = 2
//    case Completed = 7
//
//    // Expired
//    // status 1 and start date < current date
//    case Expired = 1
//
//    // Finished
//    // status 6/7 and start date < current date
//    case Finished = 6/7
//}

// Status
enum JobStatus: String {

    case Offered = "OFFERED"
    case Optioned = "OPTIONED"
    case Accepted = "ACCEPTED"
    case Unfinalised = "UNFINALISED"
    case Completed = "COMPLETED"
    case Expired = "EXPIRED"
    case Finished = "FINISHED"
}
