//
//  IDCardPhoto.swift
//  Doku
//
//  Created by Viktor Atanasoski on 12/7/24.
//
import SwiftData
import SwiftUI

// obicen model shto sodrzhi imagedata vo binaren kod, vreme na slikanje za da se sortira, i drugi atributi od licnata karta
@Model
class IDCardPhoto : Identifiable {
    @Attribute var imageData: Data?
    @Attribute var timestamp: Date
    @Attribute var name: String?
    @Attribute var surname: String?
    @Attribute var nationality: String?
    @Attribute var sex: String?
    @Attribute var dateOfBirth: Date?
    @Attribute var dateOfIssue: Date?
    @Attribute var dateOfExpiry: Date?
    @Attribute var placeOfBirth: String?
    @Attribute var permanentResidence: String?
    @Attribute var address: String?
    @Attribute var authority: String?
    @Attribute var IDNumber: Int? //M + broj
    
    init(imageData: Data?, timestamp: Date = Date(), name: String? = nil, surname: String? = nil, nationality: String? = nil, sex: String? = nil, dateofbirth: Date? = nil, dateOfIssue: Date? = nil, dateOfExpiry: Date? = nil, placeOfBirth: String? = nil, permamentResidence: String? = nil, address: String? = nil, authority: String? = nil, IDNumber: Int? = nil) {
        self.imageData = imageData
        self.timestamp = timestamp
        self.name = name
        self.surname = surname
        self.nationality = nationality
        self.sex = sex
        self.dateOfBirth = dateofbirth
        self.dateOfIssue = dateOfIssue
        self.dateOfExpiry = dateOfExpiry
        self.placeOfBirth = placeOfBirth
        self.permanentResidence = permamentResidence
        self.address = address
        self.authority = authority
        self.IDNumber = IDNumber
    }
}
