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
    @State private var idNumber : Int = 0
    @State private var editing : Bool = true
    @State private var showAlert : Bool = false
    @State private var showMap : Bool = false

    
    init(slika: IDCardPhoto) { // FIX ZA BINDING vo contnentView-> mora init tuka
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
    
    let formatter: NumberFormatter = {
           let formatter = NumberFormatter()
        formatter.numberStyle = .none
           return formatter
       }()
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if let data = slika.imageData, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 400)
                    }
                    Form {
                        HStack {
                            VStack(alignment: .leading){
                                Text("Name").font(.subheadline).foregroundColor(.gray)
                                TextField("Name", text: $name)
                                    .onAppear {
                                        name = slika.name ?? "Error"
                                    }
                                    .disabled(editing)
                            }
                            VStack(alignment: .leading){
                                Text("Surname").font(.subheadline).foregroundColor(.gray)
                                TextField("Surname", text: $surname)
                                    .onAppear {
                                        surname = slika.surname ?? "Error"
                                    }
                                    .disabled(editing)
                            }
                        }
                        
                        HStack {
                            VStack(alignment: .leading){
                                Text("Nationality").font(.subheadline).foregroundColor(.gray)
                                TextField("Nationality", text: $nationality)
                                    .onAppear {
                                        nationality = slika.nationality ?? "Error"
                                    }
                                    .disabled(editing)
                            }
                            VStack(alignment: .leading){
                                Text("Sex").font(.subheadline).foregroundColor(.gray)
                                TextField("Sex", text: $sex)
                                    .onAppear {
                                        sex = slika.sex ?? "Error"
                                    }
                                    .disabled(editing)
                            }
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Date of Birth")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                DatePicker("", selection: $dateOfBirth, displayedComponents: .date)
                                    .labelsHidden()
                                    .disabled(editing)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("ID Number")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                TextField("IDNumber", value: $idNumber, formatter: formatter)
                                    .onAppear {
                                        idNumber = slika.IDNumber ?? 0
                                    }
                                    .disabled(editing)
                            }
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Date of Issue")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                DatePicker("", selection: $dateOfIssue, displayedComponents: .date)
                                    .labelsHidden()
                                    .disabled(editing)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Date of Expiry")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                DatePicker("", selection: $dateOfExpiry, displayedComponents: .date)
                                    .labelsHidden()
                                    .disabled(editing)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        HStack {
                            VStack(alignment: .leading){
                                Text("Place of Birth").font(.subheadline).foregroundColor(.gray)
                                TextField("Place of Birth", text: $placeOfBirth)
                                    .onAppear {
                                        placeOfBirth = slika.placeOfBirth ?? "Error"
                                    }
                                    .disabled(editing)
                            }
                            VStack(alignment: .leading){
                                Text("Permant Residence").font(.subheadline).foregroundColor(.gray)
                                TextField("Permanent Residence", text: $permanentResidence)
                                    .onAppear {
                                        permanentResidence = slika.permanentResidence ?? "Error"
                                    }
                                    .disabled(editing)
                            }
                        }
                        
                        HStack {
                            VStack(alignment: .leading){
                                Text("Address").font(.subheadline).foregroundColor(.gray)
                                TextField("Address", text: $address)
                                    .onAppear {
                                        address = slika.address ?? "Error"
                                    }
                                    .disabled(editing)
                            }
                            VStack(alignment: .leading){
                                Text("Authority").font(.subheadline).foregroundColor(.gray)
                                TextField("Authority", text: $authority)
                                    .onAppear {
                                        authority = slika.authority ?? "Error"
                                    }
                                    .disabled(editing)
                            }
                        }
                        Button(action: {showMap = true}){
                            Text("mapaTest")
                        }.sheet(isPresented: $showMap) {
                            MapView()
                        }
                    }
                    if !editing{
                        Section(){
                            Button("Delete", role: .destructive) {
                                showAlert.toggle()
                            }.buttonStyle(.borderedProminent).alert("izbirishi", isPresented: $showAlert){
                                Button("Delete", role: .destructive){
                                    deleteSlika()
                                }
                                Button("Cancel", role: .cancel){
                                    showAlert.toggle()
                                }
                            } message: {
                                Text("Are you sure you want to delete this ID?")
                            }
                        }
                    }
                }
            }
        }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(editing ? "Edit" : "Save"){
                        if editing{
                            saveDetails()
                        }
                        editing.toggle()
                    }
                }
            }
    }
    func deleteSlika() {
        modelContext.delete(slika)
    }
    func saveDetails() {
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
        
        do{
            try? modelContext.save() //mora so try?
            print("changes saved successfully")
        }  catch {
            print("saving changes failed")
        }
    }
    
}
