//
//  SplashScreen.swift
//  Community Hands
//
//  Created by JOURNi Student on 8/1/26.
//

import SwiftUI

// MARK: - Splash Screen
// Entry point for Community Hands app
// Shows branded animation representing community connection
// Teens and Homeowners coming together to help each other
// Transitions to WelcomeView after animation completes
struct SplashScreen: View {
    // MARK: - Animation State
    @State private var isActive = false
    
    // Logo animation
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    
    // Title animation
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = 20
    
    // Tagline animation
    @State private var taglineOpacity: Double = 0
    
    // Community connection animation
    @State private var connectionOpacity: Double = 0
    @State private var helperOffset: CGFloat = -50
    @State private var homeownerOffset: CGFloat = 50
    
    // Core values animation
    @State private var valuesOpacity: Double = 0

    // MARK: - Animation Timing
    private let logoDelay: Double = 0.2
    private let titleDelay: Double = 0.6
    private let taglineDelay: Double = 0.9
    private let connectionDelay: Double = 1.2
    private let valuesDelay: Double = 1.6
    private let transitionDelay: Double = 3.0

    var body: some View {
        ZStack {
            // MARK: - Background
            // Soft gradient background representing community and growth
            LinearGradient(
                colors: [
                    Color.white,
                    Color("primaryComHandColor").opacity(0.05)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // MARK: - Main Content
            VStack(spacing: 0) {
                Spacer()

                // MARK: - Logo & Title Section
                VStack(spacing: 16) {
                    // App Logo
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)

                    // App Name
                    Text("Community Hands")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color("primaryComHandColor"))
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)

                    // Tagline
                    Text("Connecting Teens & Homeowners")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .opacity(taglineOpacity)
                }

                Spacer()

                // MARK: - Community Connection Visual
                // Animated representation of teens helping homeowners
                ZStack {
                    // Connection line between personas
                    HStack(spacing: 60) {
                        // Teen Helper side
                        VStack(spacing: 8) {
                            Image(systemName: "person.fill.checkmark")
                                .font(.system(size: 44))
                                .foregroundColor(.blue)
                            
                            Text("Teens")
                                .font(.caption)
                                .fontWeight(.medium)
                            
                            Text("Need Experience")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .offset(x: helperOffset)
                        
                        // Connection icon - handshake showing community connection
                        Text("🫱🏾‍🫲🏿")
                            .font(.system(size: 36))
                            .opacity(connectionOpacity)
                        
                        // Homeowner side
                        VStack(spacing: 8) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 44))
                                .foregroundColor(.orange)
                            
                            Text("Homeowners")
                                .font(.caption)
                                .fontWeight(.medium)
                            
                            Text("Need Help")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .offset(x: homeownerOffset)
                    }
                }
                .opacity(connectionOpacity)

                Spacer()

                // MARK: - Core Values
                // Four pillars of the platform
                HStack(spacing: 16) {
                    ValueItem(icon: "briefcase.fill", text: "WORK")
                    ValueItem(icon: "book.fill", text: "LEARN")
                    ValueItem(icon: "dollarsign.circle.fill", text: "EARN")
                    ValueItem(icon: "arrow.up.circle.fill", text: "GROW")
                }
                .opacity(valuesOpacity)

                Spacer()
            }
            .padding(.vertical, 40)
            
            // MARK: - Welcome View Transition
            // Rendered conditionally in ZStack for smooth opacity transition
            // Replaces fullScreenCover which has non-overrideable system transition
            if isActive {
                WelcomeView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            startAnimationSequence()
        }
    }

    // MARK: - Animation Sequence
    // Unique to Community Hands - tells the story of connection
    private func startAnimationSequence() {
        // Step 1: Logo appears
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(logoDelay)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }

        // Step 2: Title slides up and fades in
        withAnimation(.easeOut(duration: 0.5).delay(titleDelay)) {
            titleOpacity = 1.0
            titleOffset = 0
        }

        // Step 3: Tagline appears
        withAnimation(.easeOut(duration: 0.4).delay(taglineDelay)) {
            taglineOpacity = 1.0
        }

        // Step 4: Community connection visual
        // Teens and homeowners "come together"
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(connectionDelay)) {
            connectionOpacity = 1.0
            helperOffset = 0
            homeownerOffset = 0
        }

        // Step 5: Core values appear
        withAnimation(.easeOut(duration: 0.5).delay(valuesDelay)) {
            valuesOpacity = 1.0
        }

        // Step 6: Transition to WelcomeView
        DispatchQueue.main.asyncAfter(deadline: .now() + transitionDelay) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isActive = true
            }
        }
    }
}

// MARK: - Value Item
// Displays one of the four core values with icon
// WORK, LEARN, EARN, GROW
struct ValueItem: View {
    let icon: String
    let text: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color("primaryComHandColor"))
            
            Text(text)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .frame(width: 60)
    }
}

// MARK: - Preview
#Preview {
    SplashScreen()
}
