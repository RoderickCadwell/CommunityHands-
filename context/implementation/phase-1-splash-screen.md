# Phase 1: Add Splash Screen

## Overview

**Objective:** Add a Splash Screen as the entry point that shows an animation, then transitions to WelcomeView.

**Priority:** Critical - App needs branded splash experience before WelcomeView

**Branch:** `fix/add-splash-screen` (to be created after approval)

---

## Problem Statement

The current app launches directly to `WelcomeView` without a branded splash screen. This misses the opportunity to:
1. Show the Community Hands brand/logo
2. Display key features/app value proposition
3. Provide a polished, professional first impression
4. Allow any necessary app initialization to happen behind the animation

---

## Changes Required

### File 1: Create `SplashScreen.swift`

**Location:** `Community Hands/Views/Onboarding/SplashScreen.swift`

**Requirements:**
- Full-screen ZStack with soft gradient background
- Animated Community Hands logo (scale + fade)
- **Unique to Community Hands** — NO feature pills (not LifeLoop)
- Visual representation of teens helping homeowners
- Core values display: WORK, LEARN, EARN, GROW
- Minimum 3s display time for full animation
- Smooth transition (fade) to WelcomeView

**Animation Sequence:**
1. Logo scales and fades in
2. App title slides up and fades in
3. Tagline "Connecting Teens & Homeowners" appears
4. **Unique:** Teens and Homeowners "come together" animation
5. **Unique:** Core values appear (WORK, LEARN, EARN, GROW icons)
6. Transition to WelcomeView

**Animation Timing:**
```swift
// MARK: - Animation Timing
// Unique to Community Hands — tells story of connection
private let logoDelay: Double = 0.2
private let titleDelay: Double = 0.6
private let taglineDelay: Double = 0.9
private let connectionDelay: Double = 1.2  // Teens & Homeowners meet
private let valuesDelay: Double = 1.6      // Core values appear
private let transitionDelay: Double = 3.0
```

**Code Structure:**
```swift
import SwiftUI

// MARK: - Splash Screen
// Entry point for Community Hands app
// Shows branded animation, then transitions to WelcomeView
// Minimum 1.5s display time for app initialization
struct SplashScreen: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var pillsOffset: CGFloat = 50
    
    var body: some View {
        ZStack {
            // Background
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Logo with scale animation
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                
                // App name with gradient text
                Text("Community Hands")
                    .font(.system(size: 32, weight: .bold))
                    .opacity(textOpacity)
                
                // Tagline
                Text("WORK. LEARN. EARN. GROW.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .opacity(textOpacity)
                
                Spacer()
                
                // Feature pills (horizontal scrolling)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(features, id: \.self) { feature in
                            FeaturePill(text: feature)
                        }
                    }
                    .padding(.horizontal)
                }
                .opacity(textOpacity)
                .offset(y: pillsOffset)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimationSequence()
        }
        .fullScreenCover(isPresented: $isActive) {
            WelcomeView()
        }
    }
    
    private func startAnimationSequence() {
        // Animation sequence implementation
    }
}

// MARK: - Feature Pill
// Small badge showing an MVP feature
struct FeaturePill: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color("primaryComHandColor"))
            .cornerRadius(20)
    }
}
```

---

### File 2: Update `Community_HandsApp.swift`

**Current:**
```swift
@main
struct Cummunity_HandsApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            WelcomeView()  // ❌ No splash screen
                .environmentObject(authViewModel)
        }
    }
}
```

**Fix:**
```swift
// MARK: - Community Hands App Entry Point
// Launches SplashScreen first, which transitions to WelcomeView
// SplashScreen provides branded animation and app initialization time
@main
struct Cummunity_HandsApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            SplashScreen()  // ✅ Entry point with animation
                .environmentObject(authViewModel)
        }
    }
}
```

---

## Optional Fix: ContentView AuthViewModel

**File:** `ContentView.swift`

**Current:**
```swift
struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()  // ❌ Creates new instance
```

**Fix:**
```swift
// MARK: - ContentView
// Uses shared AuthViewModel from environment
// Note: This view may be unused - WelcomeView handles auth flow
struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel  // ✅ Shared instance
```

---

## Testing Checklist

- [ ] App launches to SplashScreen
- [ ] Logo scales and fades in
- [ ] "Community Hands" text appears after logo
- [ ] Feature pills scroll horizontally
- [ ] After ~1.5s, transitions to WelcomeView
- [ ] WelcomeView functions normally (Get Started, Log In)
- [ ] Auth flow works: SignUp → Terms → Bio → MainMenu
- [ ] No duplicate AuthViewModel instances (if fixing ContentView)

---

## Notes for Interns

### Why a Splash Screen?

1. **First Impression:** Users see a polished, branded experience immediately
2. **Perceived Performance:** Animation masks any app initialization time
3. **Marketing:** Feature pills remind users what the app offers
4. **Professionalism:** Every major app has a splash/launch screen

### Animation Sequence Explained

```swift
// Step 1: Logo appears (scale up + fade in)
// Step 2: App name fades in
// Step 3: Tagline fades in
// Step 4: Feature pills start scrolling
// Step 5: After delay, transition to WelcomeView
```

### Using fullScreenCover vs NavigationLink

- `fullScreenCover` is used for the splash → welcome transition
- This replaces the splash completely (not a navigation stack)
- WelcomeView then uses its own NavigationStack for auth flow

---

## Implementation Steps

1. **Create branch:** `fix/add-splash-screen`
2. **Create SplashScreen.swift:** Add file with animation logic
3. **Update Community_HandsApp.swift:** Change entry point
4. **(Optional) Fix ContentView.swift:** Use @EnvironmentObject
5. **Test:** Verify flow works end-to-end
6. **Commit:** Descriptive commit message
7. **Push:** Push branch to origin
8. **Await Approval:** Tone reviews before merge

---

## Authorization Required

**DO NOT PROCEED** without explicit approval from Tone King on:

1. [ ] This implementation plan
2. [ ] Branch name: `fix/add-splash-screen`
3. [ ] SplashScreen design approach
4. [ ] Whether to also fix ContentView AuthViewModel

---

*Document created: 2026-08-01*
*Author: Abraham (AI Assistant)*
*For: Community Hands Team*
