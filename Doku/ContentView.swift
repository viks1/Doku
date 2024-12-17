//  Doku
//
//  Created by Viktor Atanasoski on 8/15/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var imaKamera = false
    @State private var slika: UIImage?
    @State private var slika2: UIImage?
    @Environment(\.modelContext) private var modelContext
    //ova se koristi za da mozeme da upravuvame so databazata
    @Query(sort: \IDCardPhoto.timestamp, order: .reverse) var idCardPhotos: [IDCardPhoto] // da gi zeme site sliki od databazata
    @State private var counter: Int = 0 //state mora da ima vrednost pri inicijalizacija, a queryto gore e dinamicno
    @State private var editSlika = false
    //@State private var slikaTransfer: IDCardPhoto? //po bezbeden nacin
    
    //za ocr da znae na koja linija da se fokusira
    @State public var english: Bool = false
    
    @Environment(\.dismiss) private var dismiss //za cancel button
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal, showsIndicators: false) { //da nema scrollbar
                HStack {
                    ForEach(idCardPhotos) { photo in
                        if let data1 = photo.imageData, let image1 = UIImage(data: data1), //go pretvorame vo UIslika za da mozhe da se prikazhe
                            let data2 = photo.imageData2, let image2 = UIImage(data: data2) {
                            NavigationLink(destination: EditSlikaView(slika: photo)) { //pri klik se otvara edits
                                Image(uiImage: image1)
                                    .resizable()
                                    .frame(width: 200, height: 300)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .rotationEffect(Angle(degrees: 90))
                            }
                        }
                    }
                }
                .onAppear {
                    counter = idCardPhotos.count
                }
            }
        }
        //Text("Broj na ID's : \(counter)")

        Button(action: { imaKamera = true }) {
            Label("Slikaj", systemImage: "camera")
        }
        .sheet(isPresented: $imaKamera) {
            CameraView(slika: $slika, slika2: $slika2){
                slika, slika2 in savePhotoToSwiftData(slika: slika, slika2: slika2)
            }
            //Button("Cancel") {
              //  dismiss()
            // }
        }
        
        
            }
    
    func savePhotoToSwiftData(slika: UIImage, slika2: UIImage) {
        guard let imageData = slika.jpegData(compressionQuality: 0.8),
              let imageData2 = slika2.jpegData(compressionQuality: 0.8) else {
            print("Neupesno konvertiranje")
            return
        }
        
        
        //let newId = IDCardPhoto(imageData: imageData) //pravime model
        
        processOCR(image: slika) { extractedText in
            DispatchQueue.main.async {
                let parsedData = parseIDCardText(extractedText)
                let parsedData2 = parseIDCardText(extractedText)
                
                parsedData.imageData = imageData
                parsedData2.imageData2 = imageData2
                
                modelContext.insert(parsedData)
                
                //modelContext.insert(newId) //go stavame vo contextot
                
                do {
                    try modelContext.save()
                    print("uspesno zacuvuvanje vo databaza")
                } catch {
                    print("neuspesno zacuvuvanje")
                }
            }
            
            
            struct ContentViewPreview: PreviewProvider {
                static var previews: some View {
                    ContentView()
                }
            }
        }
    }
}
