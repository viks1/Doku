//  Doku
//
//  Created by Viktor Atanasoski on 8/15/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var imaKamera = false
    @State private var slika: UIImage?
    @Environment(\.modelContext) private var modelContext
    //ova se koristi za da mozeme da upravuvame so databazata
    @Query(sort: \IDCardPhoto.timestamp, order: .reverse) var idCardPhotos: [IDCardPhoto] // da gi zeme site sliki od databazata


    
    var body: some View {
        NavigationView{
            VStack{
                ForEach(idCardPhotos, id: \.self) { photo in
                    if let data = photo.imageData, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 500, height: 250)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
                Button(action: { imaKamera = true }) {
                    Label("Slikaj", systemImage: "camera")
                }.padding()
                    .sheet(isPresented: $imaKamera) {
                        CameraView(slika: $slika, onsave: savePhotoToSwiftData)
                    }
            }
        }.padding().navigationTitle("Doku")
    }
    
    func savePhotoToSwiftData(slika: UIImage) {
        guard let imageData = slika.jpegData(compressionQuality: 0.8) else {
            print("Neupesno konvertiranje")
            return
        }
        
        let newId = IDCardPhoto(imageData: imageData) //pravime model
        modelContext.insert(newId) //go stavame vo contextot
        
        do {
            try modelContext.save()
            print("uspesno zacuvuvanje vo databaza")
        } catch {
            print("neuspesno zacuvuvanje")
        }
    }
    
    
    struct ContentViewPreview: PreviewProvider {
        static var previews: some View {
            ContentView() }
    }
}
