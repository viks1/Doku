//
//  EditSlikaView.swift
//  Doku
//
//  Created by Viktor Atanasoski on 12/9/24.
//

import SwiftUI
import SwiftData

struct EditSlikaView: View {
    
    
    @Environment(\.modelContext) private var modelContext
    var slika : IDCardPhoto
    @State private var name : String
    @State private var surname : String
    @State private var nationality : String
    @State private var sex : String
    @State private var dateOfBirth : Date
    @State private var dateOfIssue : Date
    @State private var dateOfExpiry : Date
    @State private var placeOfBirth : String
    @State private var permanentResidence : String
    @State private var address : String
    @State private var authority : String
    @State private var idNumber : Int //to-do implement num count
    
    init(slika: IDCardPhoto) { // FIX ZA BINDING vo contnentView-> mora init
            self.slika = slika
            _name = State(initialValue: slika.name ?? "name")
            _surname = State(initialValue: slika.surname ?? "surname")
            _nationality = State(initialValue: slika.nationality ?? "nationality")
            _sex = State(initialValue: slika.sex ?? "sex")
            _dateOfBirth = State(initialValue: slika.dateOfBirth ?? Date.now)
            _dateOfIssue = State(initialValue: slika.dateOfIssue ?? Date.now)
            _dateOfExpiry = State(initialValue: slika.dateOfExpiry ?? Date.now)
            _placeOfBirth = State(initialValue: slika.placeOfBirth ?? "placeOfBirth")
            _permanentResidence = State(initialValue: slika.permanentResidence ?? "permanentResidence")
            _address = State(initialValue: slika.address ?? "address")
            _authority = State(initialValue: slika.authority ?? "authority")
            _idNumber = State(initialValue: slika.IDNumber ?? 0)
        }
    
    
    var body: some View {
        NavigationView{
            VStack{
                if let data = slika.imageData, let image = UIImage(data: data) {
                    Image(uiImage: image).resizable().aspectRatio(contentMode: .fit)
                }
                Form{
                    TextField("name", text: $name).onAppear {
                        name = slika.name ?? "Default"
                    }
                    TextField("surname", text: $surname).onAppear {
                        surname = slika.surname ?? "Default"
                    }
                    TextField("nationality", text: $nationality).onAppear {
                        nationality = slika.nationality ?? "Default"
                    }
                    TextField("sex", text: $sex).onAppear {
                        sex = slika.sex ?? "Default"
                    }
                    DatePicker("dateOfbirth", selection: $dateOfBirth).onAppear {
                        dateOfBirth = slika.dateOfBirth ?? Date.now
                    }
                    DatePicker("dateOfIssue", selection: $dateOfIssue).onAppear {
                        dateOfIssue = slika.dateOfIssue ?? Date.now
                    }
                    DatePicker("dateOfExpiry", selection: $dateOfExpiry).onAppear {
                        dateOfExpiry = slika.dateOfExpiry ?? Date.now
                    }
                    TextField("placeOfBirth", text: $placeOfBirth).onAppear {
                        placeOfBirth = slika.placeOfBirth ?? "Default"
                    }
                    TextField("permamentResidence", text: $permanentResidence).onAppear {
                        permanentResidence = slika.permanentResidence ?? "Default"
                    }
                    TextField("address", text: $address).onAppear {
                        address = slika.address ?? "Default"
                    }
                    TextField("authority", text: $authority).onAppear {
                        authority = slika.authority ?? "Default"
                    }
                    //Number("IDNumber", text: $idNumber).onAppear {
                     //   idNumber = slika.idNumber ?? "Default"
                    //}
                }
                HStack{
                    Button("Save"){
                        saveDetails()
                    }
                    
                    Button("Delete") {
                        deleteSlika()
                    }//.offset(x: -50, y: 300)
                }
            }}
    }
    func deleteSlika() {
        modelContext.delete(slika)
    }
    func saveDetails() { //ne mora modelContext.save
        slika.name = name
        slika.surname = surname
        slika.nationality = nationality
        slika.sex = sex
        slika.dateOfBirth = dateOfBirth
        slika.dateOfIssue = dateOfIssue
        slika.dateOfExpiry = dateOfExpiry
        slika.placeOfBirth = placeOfBirth
        slika.permanentResidence = permanentResidence
        slika.address = address
        slika.authority = authority
        slika.IDNumber = idNumber
        
        try? modelContext.save() //mora so try?
    }
    
}
