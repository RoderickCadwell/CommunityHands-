//
//  Cummunity_HandsApp.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import SwiftUI

@main
struct Cummunity_HandsApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
        }
    }
}
