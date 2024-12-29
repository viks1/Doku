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
        picker.cameraDevice = .rear // da ne gi vrti site 3 kameri
        picker.cameraFlashMode = .off //.off ima podobri rezultati ama vo temna prostorija ne e dobro
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
        var instrukcii: UILabel?
        
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        //pravi overlay za custom kamerata i go stava kopcheto vnatre
        func customDisplay() -> UIView {
            let overlay = UIView(frame: UIScreen.main.bounds)
            overlay.backgroundColor = .clear
            
            //da go ima oblikot na licnata krata
            let maska = UIBezierPath(rect: UIScreen.main.bounds) //nadvoresniot del (crn)
            let prozorche = UIBezierPath(roundedRect: CGRect(x: UIScreen.main.bounds.width * 0.15,
                                                             y: UIScreen.main.bounds.height * 0.3, width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.2),cornerRadius: 10)
            maska.append(prozorche) //ova go pravi prodzirniot del vo sredina kade shto treba da bide licnata karta
            maska.usesEvenOddFillRule = true
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = maska.cgPath
            maskLayer.fillRule = .evenOdd
            maskLayer.fillColor = UIColor.black.cgColor
            maskLayer.opacity = 0.8
            overlay.layer.addSublayer(maskLayer)
            
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
            
            let instrukcii = UILabel(frame: CGRect(x: 20, y: UIScreen.main.bounds.height * 0.15, width: UIScreen.main.bounds.width - 40,height: 50))
            instrukcii.textAlignment = .center
            instrukcii.textColor = .white
            instrukcii.font = UIFont.boldSystemFont(ofSize: 18)
            instrukcii.text = "Take a picture of the front side"
            overlay.addSubview(instrukcii)
            
            self.instrukcii = instrukcii
            
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
            if var image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                if !prednaSlikana {
                    parent.slika = image
                    prednaSlikana = true
                    print("predna strana slikana")
                    instrukcii?.text = "Take a picture of the back side"
                } else {
                    parent.slika2 = image
                    print("zadna strana slikana")
                    if let slika1 = parent.slika {
                        parent.onsave(slika1, image)
                    }
                    scheduleNotification()
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
func scheduleNotification() {
    let content = UNMutableNotificationContent()
    content.title = "ID card saved!"
    content.body = "You can view your ID card in the main screen."
    content.sound = .default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    //ja prakja vo notification center
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("error sending notification \(error.localizedDescription)")
        } else {
            print("notification sent!")
        }
    }
}
