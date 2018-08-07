//
//  DictionaryExtensions.swift
//  Finda
//
//  Created by Peter Lloyd on 07/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation


extension Dictionary where Value : Equatable {
    func allKeysForValue(val : Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}
