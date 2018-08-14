//
//  PhotoManager.swift
//  Finda
//
//  Created by Peter Lloyd on 14/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

class PhotoManager {
    
    static func getPhotos(imageType: ImageType, completion: @escaping (_ response: Bool, _ result: JSON, _ Photos: [Photo]) -> ()){
        FindaAPISession(target: .getImages(type: imageType)) { (response, result) in
            if(response){
                
                var photosArray: [Photo] = []
                for photo in result["userdata"].arrayValue {
                    photosArray.append(Photo(data: photo))
                }
                
                completion(response, result, photosArray)
                return
            }
            completion(false, result, [])
        }
    }
    
}
