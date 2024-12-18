//
//  CameraView.swift
//  Doku
//
//  Created by Viktor Atanasoski on 12/7/24.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable { //ova ni ovozmozuva da slikame so kamerata na telefonot
    @Binding var slika: UIImage? //go bindame za da mozheme da go vratime nazad na roditel klasata
    @Binding var slika2: UIImage?
    var onsave: (UIImage, UIImage) -> Void
    
    @Environment(\.presentationMode) private var presentationMode //da se izgasi samiot view koga kje zavrshi ili kje bide cancel
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.cameraFlashMode = .on
        picker.showsCameraControls = false //ako e enabled gi imame site kontroli vrz kamerata (flash,zoom..)
        //za custom kontrola
        picker.cameraOverlayView = context.coordinator.customDisplay()
        context.coordinator.slikaj = picker
        
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
        var slikaj: UIImagePickerController?
        var prednaSlikana: Bool = false
        
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        //pravi overlay za custom kamerata i go stava kopcheto vnatre
        func customDisplay() -> UIView {
            let overlay = UIView(frame: UIScreen.main.bounds)
            overlay.backgroundColor = .clear
            
            //hardcoded za iphone 16 pro :(
            let slikaj = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2 - 40, y: UIScreen.main.bounds.height * 0.70, width: 80, height: 80))
            slikaj.backgroundColor = UIColor.systemBlue
            slikaj.layer.borderColor = UIColor.white.cgColor
            slikaj.layer.borderWidth = 2
            slikaj.layer.cornerRadius = 40
            slikaj.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
            overlay.addSubview(slikaj)
            
            let cancel = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/5 - 80.5, y: UIScreen.main.bounds.height - 875, width: UIScreen.main.bounds.width, height: 80))
            cancel.setTitle("Cancel", for: .normal)
            cancel.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
            cancel.backgroundColor = UIColor.black
            overlay.addSubview(cancel)
            
            return overlay
        }
        
        // za kamera button
        @objc func takePicture() {
            slikaj?.takePicture()
        }
        
        // za cancel button
        @objc func cancelAction() {
            parent.presentationMode.wrappedValue.dismiss()
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                if !prednaSlikana {
                    parent.slika = image
                    prednaSlikana = true
                    print("predna strana slikana")
                } else {
                    parent.slika2 = image
                    print("zadna strana slikana")
                    if let slika1 = parent.slika {
                        parent.onsave(slika1, image)
                    }
                    parent.presentationMode.wrappedValue.dismiss()
                }
            } else {
                parent.presentationMode.wrappedValue.dismiss()
                //avtomatski go gasi pickerot
            }
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss() //manuelno gasenje na pickerot, nishto ne vrakja nazad do roditelot
        }
    }
}
