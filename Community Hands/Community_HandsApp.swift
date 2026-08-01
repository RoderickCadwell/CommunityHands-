//
//  Cummunity_HandsApp.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import SwiftUI

// MARK: - Community Hands App Entry Point
// Launches SplashScreen first, which transitions to WelcomeView
// SplashScreen provides branded animation and app initialization time
@main
struct Cummunity_HandsApp: App {
    // MARK: - Auth View Model
    // Shared authentication state across entire app
    // Passed via environmentObject to all child views
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            // SplashScreen is the entry point
            // Shows logo animation, then transitions to WelcomeView
            SplashScreen()
                .environmentObject(authViewModel)
        }
    }
}
