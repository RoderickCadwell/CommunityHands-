//
//  SplashScreen.swift
//  Community Hands
//
//  Created by JOURNi Student on 8/1/26.
//

import SwiftUI

// MARK: - Splash Screen
// Entry point for Community Hands app
// Shows branded animation with logo and feature highlights
// Transitions to WelcomeView after animation completes
// Minimum 1.5s display time for app initialization
struct SplashScreen: View {
    // MARK: - Animation State
    // Tracks whether to show WelcomeView (animation complete)
    @State private var isActive = false
    
    // Logo animation states
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    
    // Text animation states
    @State private var textOpacity: Double = 0
    @State private var taglineOpacity: Double = 0
    
    // Feature pills animation
    @State private var pillsOpacity: Double = 0
    @State private var pillsOffset: CGFloat = 30

    // MARK: - Animation Timing
    // Defines the delays for sequential animations
    // Logo appears first, then text, then pills scroll
    private let logoAnimationDelay: Double = 0.2
    private let textAnimationDelay: Double = 0.5
    private let taglineAnimationDelay: Double = 0.7
    private let pillsAnimationDelay: Double = 0.9
    private let transitionDelay: Double = 2.5
    
    // MARK: - Feature Pills Data
    // MVP features to display in scrolling pills
    private let features = [
        "Lawn Care",
        "Pet Care",
        "Babysitting",
        "Car Wash",
        "Tutoring"
    ]

    var body: some View {
        ZStack {
            // MARK: - Background
            // Clean white background for branded look
            Color.white.ignoresSafeArea()

            // MARK: - Main Content Stack
            VStack(spacing: 30) {
                Spacer()

                // MARK: - Logo Section
                // Community Hands logo with scale animation
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)

                // MARK: - App Name
                // "Community Hands" title with brand color
                Text("Community Hands")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(Color("primaryComHandColor"))
                    .opacity(textOpacity)

                // MARK: - Tagline
                // Brand tagline describing the mission
                Text("WORK. LEARN. EARN. GROW.")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                    .opacity(taglineOpacity)

                Spacer()

                // MARK: - Feature Pills
                // Horizontal scrolling pills showing MVP features
                // Auto-scrolls to show all available services
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(features, id: \.self) { feature in
                            FeaturePill(text: feature)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .opacity(pillsOpacity)
                .offset(y: pillsOffset)
                .disabled(true) // Disable user interaction, just visual

                Spacer()
            }
            .padding(.vertical, 40)
        }
        // MARK: - Animation Sequence
        // Triggers when view appears
        .onAppear {
            startAnimationSequence()
        }
        // MARK: - Navigation
        // Full screen cover transitions to WelcomeView
        // Uses opacity transition for smooth fade
        .fullScreenCover(isPresented: $isActive) {
            WelcomeView()
                .transition(.opacity)
        }
    }

    // MARK: - Animation Sequence
    // Coordinates all animations with timing
    // Step 1: Logo scales up and fades in
    // Step 2: App name fades in
    // Step 3: Tagline fades in
    // Step 4: Feature pills fade in and slide up
    // Step 5: After delay, transition to WelcomeView
    private func startAnimationSequence() {
        // Step 1: Logo animation (scale + fade)
        withAnimation(.easeOut(duration: 0.6).delay(logoAnimationDelay)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }

        // Step 2: App name fade in
        withAnimation(.easeOut(duration: 0.5).delay(textAnimationDelay)) {
            textOpacity = 1.0
        }

        // Step 3: Tagline fade in
        withAnimation(.easeOut(duration: 0.5).delay(taglineAnimationDelay)) {
            taglineOpacity = 1.0
        }

        // Step 4: Feature pills fade in and slide up
        withAnimation(.easeOut(duration: 0.5).delay(pillsAnimationDelay)) {
            pillsOpacity = 1.0
            pillsOffset = 0
        }

        // Step 5: Transition to WelcomeView after total duration
        // Gives user time to see all branding elements
        DispatchQueue.main.asyncAfter(deadline: .now() + transitionDelay) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isActive = true
            }
        }
    }
}

// MARK: - Feature Pill
// Small badge showing an MVP feature/service
// Used in horizontal scroll view on splash screen
struct FeaturePill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color("primaryComHandColor"))
            )
    }
}

// MARK: - Preview
// In-memory container for preview
// Shows splash screen with sample animation state
#Preview {
    SplashScreen()
}
