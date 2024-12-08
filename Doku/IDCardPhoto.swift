//
//  IDCardPhoto.swift
//  Doku
//
//  Created by Viktor Atanasoski on 12/7/24.
//
import SwiftData
import SwiftUI

// obicen model shto sodrzhi imagedata vo binaren kod, vreme na slikanje za da se sortira
@Model
class IDCardPhoto {
    @Attribute var imageData: Data?
    @Attribute var timestamp: Date
    
    init(imageData: Data?, timestamp: Date = Date()) {
        self.imageData = imageData
        self.timestamp = timestamp
    }
}
