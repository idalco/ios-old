//
//  NotificationNames.swift
//  Finda
//

import Foundation

extension Notification.Name {
    static let userLoggedOut = Notification.Name("USER_LOGGED_OUT")
    static let userLoggedIn = Notification.Name("USER_LOGGED_IN")
    static let avatarChanged = Notification.Name("AVATAR_CHANGED")
    static let reachabilityChanged = Notification.Name("REACHABILITY_CHANGED")
}
