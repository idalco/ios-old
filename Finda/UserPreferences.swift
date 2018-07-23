//
//  UserPreferences.swift
//  Finda
//
//  Created by cro on 23/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import Marshal

final class UserPreferences: NSObject, Unmarshaling {
    let jobOffered: Int
    let friendRegisters: Int
    let jobCancelled: Int
    let paymentMade: Int
    let notifications: Int
    
    init(jobOffered: Int, friendRegisters: Int, jobCancelled: Int, paymentMade: Int, notifications: Int) {
        self.jobOffered = jobOffered
        self.friendRegisters = friendRegisters
        self.jobCancelled = jobCancelled
        self.paymentMade = paymentMade
        self.notifications = notifications
    }
    
    init(object: MarshaledObject) throws {
        jobOffered = try object.value(for: "job_offered")
        friendRegisters = try object.value(for: "friend_registers")
        jobCancelled = try object.value(for: "job_cancelled")
        paymentMade = try object.value(for: "payment_made")
        notifications = try object.value(for: "notifications")
    }
}
