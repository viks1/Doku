//
//  InterfaceTestView.swift
//  Doku
//
//  Created by Viktor Atanasoski on 12/26/24.
//

import SwiftUI

struct InterfaceTestView: View {
    
    @State public var name: String = "Viktor"
    @State public var date: Date = Date()

    var body: some View {
        NavigationView{
            //mora resizeable inace nema da mozhe edit
            //Image("example_id").resizable().frame(width: 350, height: 200).position(x: (UIScreen.main.bounds.width/2), y: (UIScreen.main.bounds.height/7))
            VStack{
                HStack{
                    TextField("name", text: $name)
                    TextField("surname", text: $name)
                }
                HStack{
                    TextField("nationality", text: $name)
                    TextField("sex", text: $name)
                }
                HStack{
                    DatePicker("", selection: $date)
                    DatePicker("", selection: $date)
                }
            }
        }
    }
}

#Preview {
    InterfaceTestView()
}
