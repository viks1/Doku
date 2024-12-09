//
//  EditSlikaView.swift
//  Doku
//
//  Created by Viktor Atanasoski on 12/9/24.
//

import SwiftUI
import SwiftData

struct EditSlikaView: View {
    
    
    @Environment(\.modelContext) private var modelContext
    public var slika : IDCardPhoto
    
    
    var body: some View {
        NavigationView{
            VStack{
                Button("Close") {
                    
                }.offset(x: +50, y: 320)
                Button("Delete") {
                    deleteSlika()
                }//.offset(x: -50, y: 300)
            }}
    }
    func deleteSlika() {
        modelContext.delete(slika)
    }
}
    
