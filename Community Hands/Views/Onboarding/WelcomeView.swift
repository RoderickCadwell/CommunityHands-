//
//  WelcomeView.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import SwiftUI

struct WelcomeView: View {
    @State private var showLoadingScreen = false
    @State private var navigateToSignUp = false
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 45) {
                    Text("Community Hands")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("primaryComHandColor"))

                    Image("logo")
                        .resizable()
                        .frame(width: 250, height: 250)

                    // CTA Buttons
                    VStack {
                        // Button for Get Started (Triggers Loading Animation)
                        Button(action: {
                            withAnimation {
                                showLoadingScreen = true
                            }
                        }) {
                            Text("Get Started")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color("primaryComHandColor"))
                                )
                                .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 4)
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)

                        // Already have an account
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .font(.system(size: 15, weight: .regular))

                            Button(action: {
                                navigateToLogin = true
                            }) {
                                Text("Log in")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color("primaryComHandColor"))
                            }
                        }
                    }
                }

                // Modern Navigation Destinations (Fixes Xcode Warnings)
                .navigationDestination(isPresented: $navigateToSignUp) {
                    SignUpView()
                }
                .navigationDestination(isPresented: $navigateToLogin) {
                    LoginView()
                }

                // Loading Overlay on Welcome Screen
                if showLoadingScreen {
                    LoadingView(mode: .welcome, isLoading: $showLoadingScreen) {
                        navigateToSignUp = true
                    }
                    .transition(.opacity)
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AuthViewModel())
}
