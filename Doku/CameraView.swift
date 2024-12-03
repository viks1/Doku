//
//  CameraView.swift
//  Doku
//
//  Created by Viktor Atanasoski on 12/3/24.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var model = FrameHandler()
    
    var body: some View {
        VStack{
            FrameView(image: model.frame)//.ignoresSafeArea()
        }.navigationTitle("New ID")
    }
}

struct CameraViewPreview: PreviewProvider {
    static var previews: some View {
        CameraView() }
}
