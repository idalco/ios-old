//
//  Photo.swift
//  Finda
//
//  Created by Peter Lloyd on 14/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

class Photo {
    
    var filename: String
    var id: Int
    var imagetype: ImageType
    var leadimage: Bool
    
    init(data: JSON) {
        self.filename = data["filename"].stringValue
        self.id = data["id"].intValue
        self.imagetype = ImageType(rawValue: data["imagetype"].stringValue) ?? ImageType.Polaroids
        self.leadimage = data["leadimage"].boolValue
        
    }
    
}
