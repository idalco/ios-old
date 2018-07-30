//
//  StringExtensions.swift
//  Finda
//
//  Created by Peter Lloyd on 28/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
