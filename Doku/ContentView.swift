//
//  ContentView.swift
//  Doku
//
//  Created by Viktor Atanasoski on 8/15/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView{
            VStack {
                NavigationLink(destination: CameraView()){
                Label("Add new ID", systemImage: "camera")
                }.navigationTitle("Doku")
            }
        }
    }
    struct ContentViewPreview: PreviewProvider {
        static var previews: some View {
            ContentView() }
    }
}
