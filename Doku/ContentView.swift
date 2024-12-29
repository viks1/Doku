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
    
    //za ocr da znae na koja linija da se fokusira TODO
    @State public var english: Bool = false
    
    @Environment(\.dismiss) private var dismiss //za cancel button
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal, showsIndicators: false) { //da nema scrollbar
                HStack {
                    ForEach(idCardPhotos) { photo in
                        if let data1 = photo.imageData, let image1 = UIImage(data: data1) { //go pretvorame vo UIslika za da mozhe da se prikazhe
                            NavigationLink(destination: EditSlikaView(slika: photo)) { //pri klik se otvara edits
                                Image(uiImage: image1)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .rotationEffect(Angle(degrees: 90))
                                    .transition(.move(edge: .leading)) //od levo se stava nova
                                    .offset(x: 0, y: 0)
                                    .animation(.easeInOut(duration: 0.5), value: idCardPhotos.count)
                            }
                        }
                    }
                }
                .onAppear {
                    counter = idCardPhotos.count
                }
                if counter==0 {
                    Text("welcome to Doku, tap the camera button to take a picture of your ID :)").frame(width: 350).position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/6)
                }
            }.frame(height: 300)
                .navigationTitle(Text("Doku"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { imaKamera = true }) {
                            Label("Slikaj", systemImage: "camera")
                        }.sensoryFeedback(.success, trigger: imaKamera)
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        if counter > 0 {
                            Text("\(counter)")
                        }

                    }
                }
                .sheet(isPresented: $imaKamera) {
                    CameraView(slika: $slika, slika2: $slika2) { slika, slika2 in
                        savePhotoToSwiftData(slika: slika, slika2: slika2)
                        //gi zema od cameraView dvata objekta
                    }
                }
        }
    }
    
    func savePhotoToSwiftData(slika: UIImage, slika2: UIImage) { // se prakjaat tuka kade shto se pretvoraat vo jpeg
        guard let imageData = slika.jpegData(compressionQuality: 0.8),
              let imageData2 = slika2.jpegData(compressionQuality: 0.8) else {
            print("Neupesno konvertiranje")
            return
        }
        
        //za dvete strani
        processOCR(image: slika) { predenText in
            processOCR(image: slika2) { zadenText in
                DispatchQueue.main.async {
                    let kombiniranText = predenText + "\n" + zadenText
                    let parsedData = parseIDCardText(kombiniranText)
                    
                    parsedData.imageData = imageData
                    parsedData.imageData2 = imageData2
                    
                    modelContext.insert(parsedData)
                    
                    //modelContext.insert(newId) //go stavame vo contextot
                    
                    do {
                        try modelContext.save()
                        print("uspesno zacuvuvanje vo databaza")
                    } catch {
                        print("neuspesno zacuvuvanje")
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
