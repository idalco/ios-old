//
//  PickerDelegate.swift
//  Finda
//
//  Created by Peter Lloyd on 29/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import Eureka

class PickerDelegate {
    
    static func addPickerData(term: TermDataManager.TermData, rowTitle: String, coreData: Int, completion: @escaping (_ response: Bool, _ result: PickerInlineRow<String>) -> ()){
        var dictionary: [Int: String] = [:]
        FindaAPISession(target: .termData(term: term)) { (response, result) in
            if(response){
                for element in result["userdata"].dictionaryValue {
                    dictionary[element.value["tid"].intValue] = element.value["name"].stringValue
                }
                
                let row =  PickerInlineRow<String>() { row in
                    row.title = rowTitle
                    if row.value == nil && coreData != -1 {
                        row.value = dictionary[coreData] ?? ""
                    }
                    row.options = Array(dictionary.values)
                }
                completion(true, row)
                return
                
                
            } else {
                completion(false, PickerInlineRow())
            }
            
        }
    }
    
    static func addPickerData(term: TermDataManager.TermData, rowTitle: String, coreData: Int, completion: @escaping (_ response: Bool, _ result: PickerInlineRow<String>, _ dictionary: [Int: String]) -> ()){
        var dictionary: [Int: String] = [:]
        FindaAPISession(target: .termData(term: term)) { (response, result) in
            if(response){
                for element in result["userdata"].dictionaryValue {
                    dictionary[element.value["tid"].intValue] = element.value["name"].stringValue
                }
                
                print(dictionary)
                
                let row =  PickerInlineRow<String>() { row in
                    row.title = rowTitle
                    if row.value == nil && coreData != -1 {
                        row.value = dictionary[coreData] ?? ""
                    }
                    row.options = Array(dictionary.values)
                    row.tag = rowTitle.lowercased()
                }
                completion(true, row, dictionary)
                return
                
                
            } else {
                completion(false, PickerInlineRow(), dictionary)
            }
        }
    }
    
    static func addPickerData(rowTitle: String, coreData: Int, completion: @escaping (_ response: Bool, _ result: PickerInlineRow<String>) -> ()){
        var dictionary: [Int: String] = BooleanDictionary
        
        let row =  PickerInlineRow<String>() { row in
            row.title = rowTitle
            if row.value == nil && coreData != -1 {
                row.value = dictionary[coreData] ?? ""
            }
            row.options = Array(dictionary.values)
            row.tag = rowTitle.lowercased()
        }
        completion(true, row)
    }
}
