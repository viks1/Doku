//
//  CameraView.swift
//  Doku
//
//  Created by Viktor Atanasoski on 12/7/24.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable { //ova ni ovozmozuva da slikame so kamerata na telefonot
    @Binding var slika: UIImage? //go bindame za da mozheme da go vratime nazad na roditel klasata
    var onsave: (UIImage) -> Void
    
    @Environment(\.presentationMode) private var presentationMode //da se izgasi samiot view koga kje zavrshi ili kje bide cancel
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = true
        return picker
        //inicijalizacija na pickerot so shto go terame da ja koristi kamerata, i da mozhe da se editira slikata
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    //go menuva view pri sekoj frame
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    } //moralna funkcija za kamerata ?
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate { //tretiot ne go korisitme ama mora da bide inicijaliziran
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.slika = image //gi vrakja nazad do roditelot
                parent.onsave(image)
            }
            parent.presentationMode.wrappedValue.dismiss() //avtomatski go gasi pickerot
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss() //manuelno gasenje na pickerot, nishto ne vrakja nazad do roditelot
        }
    }
}
