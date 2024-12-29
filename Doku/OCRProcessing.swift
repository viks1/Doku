//
//  OCRProcessing.swift
//  Doku
//
//  Created by Viktor Atanasoski on 12/9/24.
//

import Foundation
import Vision
import SwiftUI
//IMPLEMENTIRAJ ENGLISH
func processOCR(image: UIImage, completion: @escaping (String) -> Void) {
    // standardna implementacija na Vision
    guard let cgImage = image.cgImage else {
        print("Failed to get CGImage from UIImage")
        completion("")
        return
    }
    		
    let request = VNRecognizeTextRequest { (request, error) in
        guard error == nil else {
            print("Text recognition problem: \(String(describing: error))")
            completion("")
            return
        }
        
        let observations = request.results as? [VNRecognizedTextObservation]
        let recognizedStrings = observations?.compactMap { observation in
            observation.topCandidates(1).first?.string
        }
        
        let fullText = recognizedStrings?.joined(separator: "\n") ?? ""
        completion(fullText)
    }
    
    //konfiguarija za jazik i preciznost
    request.recognitionLanguages = ["en"]
    request.recognitionLevel = .accurate // mozhe i fast
    	
    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    DispatchQueue.global(qos: .userInitiated).async {
        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform Vision request: \(error)")
            completion("")
        }
    }
}

func parseIDCardText(_ text: String) -> IDCardPhoto {
    //celiot tekst shto go gleda go stava vo lines, podelen po new line, mnogu cesto sobira i prazni mesta taka shto mora da se filtrira
    let lines = text.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
    
    //predna strana
    var name: String?
    var surname: String?
    var nationality: String?
    var idNumber: Int?
    var sex : String?
    
    var dateOfBirth : Date?
    var dateOfIssue : Date?
    var dateOfExpiry : Date?
    
    //zadna strana -> TO BE IMPLEMENTED
    var placeOfBirth : String?
    var permanentResidence : String?
    var address : String?
    var authority : String?

    let dateFormatter = DateFormatter() // za da pretvorime vo Date
    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    for (index, line) in lines.enumerated() {
        if line.contains("SURNAME") {
            if index + 1 < lines.count { //nullcheck
                surname = lines[index + 1] //samo go zema od nizata
            }
        } else if line.contains("GIVEN NAME") {
            if index + 1 < lines.count {
                name = lines[index + 1]
            }
        } else if line.contains("NATIONALITY") {
            if index + 1 < lines.count {
                nationality = lines[index + 1]
            }
        } else if line.contains("NIN") { //maticen broj
            if index + 1 < lines.count {
                let voString = lines[index + 1].trimmingCharacters(in: .whitespaces)
                if let maticen = Int(voString) {
                    idNumber = maticen
                }
            }
        } else if line.contains("SEX") {
            if index+1 < lines.count {
                sex = lines[index+1]
                    .trimmingCharacters(in: .whitespaces)
                    .split(separator: "/")
                    .first
                .map(String.init)} //mora da se pretvori vo string, sam ne mozhe da odredi shto kje ispadne
            /*if (sex=="M"){
                sex="Male"
            }
            else {
                sex="Female"
            }
             */
        } else if line.contains("DATE OF ISSUE") {
            if index+1 < lines.count {
                dateOfIssue = dateFormatter.date(from: lines[index+1])
            }
        } else if line.contains("DATE OF EXPIRY") {
            if index+1 < lines.count {
                dateOfExpiry = dateFormatter.date(from: lines[index+1])
            }
        } else if line.contains("DATE OF BIRTH") {
            if index+1 < lines.count {
                dateOfBirth = dateFormatter.date(from: lines[index+1])
            }
        } else if line.contains("PLACE OF BIRTH") {
            if index+1 < lines.count {
                placeOfBirth = lines[index+1].trimmingCharacters(in: .whitespaces).split(separator: "/").first.map(String.init)
            }
        } else if line.contains("PERMANENT RESIDENCE") {
            if index+1 < lines.count {
                permanentResidence = lines[index+1].trimmingCharacters(in: .whitespaces).split(separator: "/").first.map(String.init)
            }
        } else if line.contains("ADDRESS") {
            if index+1 < lines.count {
                address = lines[index+1].trimmingCharacters(in: .whitespaces)
            }
        } else if line.contains("AUTHORITY") {
            if index+1 < lines.count {
                authority = lines[index+1].trimmingCharacters(in: .whitespaces)
            }
        }// else if line.contains("ID CARD NUMBER"){
           // if index+1 < lines.count {
            //    idNumber = lines[index+1].split(separator: "M").first.map(Int.init)
            //}
        }
    return IDCardPhoto(
        imageData: nil, // go vrakjame nazad objektot so potpolneti atributi
        name: name,
        surname: surname,
        nationality: nationality,
        sex: sex,
        
        dateofbirth: dateOfBirth,
        dateOfIssue: dateOfIssue,
        dateOfExpiry: dateOfExpiry,
        
        placeOfBirth: placeOfBirth,
        permamentResidence: permanentResidence,
        address: address,
        authority: authority,
        IDNumber: idNumber
    )
}
