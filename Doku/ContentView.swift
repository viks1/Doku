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
    @State private var counter: Int = 0 //state mora da ima vrednost pri inicjalizacija, a queryto gore e dinamicno
    @State private var editSlika = false


    
    var body: some View {
        Text("Doku")
        NavigationView{
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(idCardPhotos, id: \.self) { photo in
                        if let data = photo.imageData, let image = UIImage(data: data) {
                            NavigationLink(destination: EditSlikaView(slika: photo)) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200, height: 300)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .rotationEffect(Angle(degrees: 90)) //ispravi gi
                                //.offset(y: 150)
                            }}}
                }.onAppear{
                    counter = idCardPhotos.count
                }
            }
        }
        .frame(maxWidth: .infinity)
        Button(action: { imaKamera = true }) {
            Label("Slikaj", systemImage: "camera")
        }
            .sheet(isPresented: $imaKamera) {
                CameraView(slika: $slika, onsave: savePhotoToSwiftData)
            }
        Text("Broj na ID's : \(counter)")
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
