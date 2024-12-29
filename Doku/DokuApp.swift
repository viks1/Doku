//
//  DokuApp.swift
//  Doku
//
//  Created by Viktor Atanasoski on 8/15/24.
//

import SwiftUI

@main
struct DokuApp: App {
    init(){
        requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: [IDCardPhoto.self])
    }
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("notification permission granted")
            } else {
                print("notification permission denied")
            }
        }
    }
}

