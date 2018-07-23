//
//  UserProfile.swift
//  Finda
//

import Foundation
import Marshal

final class UserProfile: NSObject, Unmarshaling {
    let height: Int
    let bust: Int
    let waist: Int
    let hips: Int
    let shoeSize: Int
    let dressSize: Int
    let hairColour: String
    let hairColourTid: Int
    let hairType: String
    let hairTypeTid: Int
    let hairLength: String
    let hairLengthTid: Int
    let eyeColour: String
    let eyeColourTid: Int    

    init(height: Int, bust: Int, waist: Int, hips: Int, shoeSize: Int, dressSize: Int, hairColour: String, hairColourTid: Int, hairType: String, hairTypeTid: Int, hairLength: String, hairLengthTid: Int, eyeColour: String, eyeColourTid: Int) {
        self.height = height
        self.bust = bust
        self.waist = waist
        self.hips = hips
        self.shoeSize = shoeSize
        self.dressSize = dressSize
        self.hairColour = hairColour
        self.hairColourTid = hairColourTid
        self.hairType = hairType
        self.hairTypeTid = hairTypeTid
        self.hairLength = hairLength
        self.hairLengthTid = hairLengthTid
        self.eyeColour = eyeColour
        self.eyeColourTid = eyeColourTid
    }
    
    init(object: MarshaledObject) throws {
        height = try object.value(for: "height")
        bust = try object.value(for: "bust")
        waist = try object.value(for: "waist")
        hips = try object.value(for: "hips")
        shoeSize = try object.value(for: "shoesize")
        dressSize = try object.value(for: "dresssize")
        hairType = try object.value(for: "hairtype_tid")
        hairTypeTid = try object.value(for: "hairtype")
        hairColour = try object.value(for: "haircolour")
        hairColourTid = try object.value(for: "haircolour_tid")
        hairLength = try object.value(for: "hairlength")
        hairLengthTid = try object.value(for: "hairlength_tid")
        eyeColour = try object.value(for: "eyecolour")
        eyeColourTid = try object.value(for: "eyecolour_tid")
    }
}
