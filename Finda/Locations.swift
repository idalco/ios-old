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
        "Barcelona",
        "Berlin",
        "Brighton",
        "Copenhagen",
        "Hamburg",
        "Liverpool",
        "London",
        "Manchester",
        "Milan",
        "Munich",
        "Newcastle",
        "Paris",
        "Stockholm",
        "Outside Europe"
    ]

    func getTidFromName(name: String) -> Int {
        var tid = 93
        switch (name) {
            case "Amsterdam":
                tid = 99
                break
            case "Barcelona":
                tid = 107
                break
            case "Berlin":
                tid = 100
                break
            case "Brighton":
                tid = 96
                break
            case "Copenhagen":
                tid = 108
                break
            case "Hamburg":
                tid = 102
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
            case "Milan":
                tid = 106
                break
            case "Munich":
                tid = 103
                break
            case "Outside Europe":
                tid = 122
                break
            case "Newcastle":
                tid = 95
                break
            case "Paris":
                tid = 98
                break
            case "Stockholm":
                tid = 109
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
        case 107:
            name = "Barcelona"
            break
        case 100:
            name = "Berlin"
            break
        case 96:
            name = "Brighton"
            break
        case 108:
            name = "Copenhagen"
            break
        case 102:
            name = "Hamburg"
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
        case 106:
            name = "Milan"
            break
        case 103:
            name = "Munich"
            break
        case 122:
            name = "Outside Europe"
            break
        case 95:
            name = "Newcastle"
            break
        case 98:
            name = "Paris"
            break
        case 109:
            name = "Stockholm"
            break
        default:
            name = "London"
            break
        }
        return name
    }
}
