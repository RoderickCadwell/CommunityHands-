//
//  AuthViewModel.swift
//  Cummunity Hands
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if !authViewModel.isAuthenticated {
                WelcomeView()
            } else {
                MainMenuView()
            }
        }
        .animation(.easeInOut, value: authViewModel.isAuthenticated)
    }
}

#Preview {
    RootView()
        .environmentObject(AuthViewModel())
}
