//
//  AuthViewModel.swift
//  Community Hands
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if !authViewModel.isAuthenticated {
                // Step 1: Not Logged In -> Welcome / Login / SignUp
                WelcomeView()
            } else if !authViewModel.hasCompletedOnboarding {
                // Step 2: New Sign Up -> Terms & Policies / Bio Flow
                TermsAndPoliciesView()
            } else {
                // Step 3: Logged In & Onboarded -> Main Menu
                MainMenuView()
            }
        }
        .animation(.easeInOut, value: authViewModel.isAuthenticated)
        .animation(.easeInOut, value: authViewModel.hasCompletedOnboarding)
    }
}

#Preview {
    RootView()
        .environmentObject(AuthViewModel())
}
