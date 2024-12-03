//
//  FrameView.swift
//  Doku
//
//  Created by Viktor Atanasoski on 12/3/24.
//

import SwiftUI

struct FrameView: View {
    var image: CGImage?
    private let label = Text("frame")
    
    var body: some View {
        if let image = image {
            Image(image, scale: 2.5, orientation: .up, label: label)
        } else {
            Color.black
        }
    }
    
    struct FrameView_Previews: PreviewProvider {
        static var previews: some View {
            FrameView() }
    }
}
