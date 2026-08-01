//
//  WelcomeView.swift
//  Community Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import SwiftUI

// MARK: - Welcome View
// Entry point after SplashScreen
// Updated per Tone's design: NavigationLink to Tour
// Tour then guides user to SignUp
struct WelcomeView: View {
    // MARK: - Navigation
    // No state needed - using NavigationLink directly for clean, declarative navigation
    // Tour handles the SignUp flow; Login is direct NavigationLink

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 45) {
                    // MARK: - Branding
                    Text("Community Hands")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("primaryComHandColor"))

                    Image("logo")
                        .resizable()
                        .frame(width: 250, height: 250)

                    // MARK: - CTA Buttons
                    VStack {
                        // MARK: - Tour Navigation
                        // "Come in our Neighborhood" navigates to InteractiveTour
                        // Tour then guides user to SignUp at completion
                        NavigationLink(destination: InteractiveTourView()) {
                            Text("Come in our Neighborhood")
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

                        // Already have an account - Log in as NavigationLink for consistency
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .font(.system(size: 15, weight: .regular))

                            NavigationLink(destination: LoginView()) {
                                Text("Log in")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color("primaryComHandColor"))
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AuthViewModel())
}
