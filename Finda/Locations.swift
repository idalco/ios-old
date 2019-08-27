//
//  Locations
//  Finda
//
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation

// @TODO this array needs to be retrieved from the server

class Locations {
    
    static let locations = [
        "Amsterdam",
        "Berlin",
        "Brighton",
        "Liverpool",
        "London",
        "Manchester",
        "New York",
        "Newcastle",
        "Paris"
    ]

    func getTidFromName(name: String) -> Int {
        var tid = 93
        switch (name) {
            case "Amsterdam":
                tid = 99
                break
            case "Berlin":
                tid = 100
                break
            case "Brighton":
                tid = 96
                break
            case "Liverpool":
                tid = 97
                break
            case "London":
                tid = 93
                break
            case "Manchester":
                tid = 94
                break
            case "New York":
                tid = 101
                break
            case "Newcastle":
                tid = 95
                break
            case "Paris":
            tid = 98
                break
            default:
                tid = 93
                break
        }
        return tid
    }
    
    func getNameFromTid(tid: Int) -> String {
        var name = "London"
        switch (tid) {
        case 99:
            name = "Amsterdam"
            break
        case 100:
            name = "Berlin"
            break
        case 96:
            name = "Brighton"
            break
        case 97:
            name = "Liverpool"
            break
        case 93:
            name = "London"
            break
        case 94:
            name = "Manchester"
            break
        case 101:
            name = "New York"
            break
        case 95:
            name = "Newcastle"
            break
        case 98:
            name = "Paris"
            break
        default:
            name = "London"
            break
        }
        return name
    }
}
