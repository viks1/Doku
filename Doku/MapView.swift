//
//  MapView.swift
//  Doku
//
//  Created by Viktor Atanasoski on 12/29/24.
//


//todo add the address from the id here
import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @Environment(\.dismiss) var dismiss
    //adresata dobiena od edit screen
    var adresa: String = "Руѓер Бошковиќ 16"
    //inicijalizacija na region za mapata
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )

    var body: some View {
        VStack {
            Map(coordinateRegion: $region)
                .onAppear {
                    geoAdresa()
                }
            Button {
                self.dismiss()
            } label: {
                Text("Close")
            }
        }
    }
    
    //od tekst vo koordinati
    func geoAdresa() {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(adresa) { placemarks, error in
                guard let location = placemarks?.first?.location else { return }
                
                DispatchQueue.main.async {
                    region.center = location.coordinate
                }
            }
        }
}

#Preview {
    MapView(adresa: "Руѓер Бошковиќ 16")
}
