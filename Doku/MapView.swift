//
//  MapView.swift
//  Doku
//
//  Created by Viktor Atanasoski on 12/29/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    var body: some View {
        Map()
        Button {
        } label: {
            Text("Close")
        }
    }
}

#Preview {
    MapView()
}
