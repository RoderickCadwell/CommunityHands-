//
//  Cummunity_HandsApp.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import SwiftUI
import SwiftData

@main
struct Cummunity_HandsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [JobItem.self, UserProfile.self])
    }
}
