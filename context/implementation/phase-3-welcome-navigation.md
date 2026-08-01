# Phase 3: WelcomeView Navigation Update

## Overview

**Objective:** Update WelcomeView navigation to use NavigationLink for "Come in our Neighborhood" button that goes to Tour.

**Priority:** High — Required for new user flow

**Branch:** `feature/welcome-navigation` (to be created after Phase 2)

**Note:** This can be combined with Phase 2 if desired.

---

## Problem Statement

The intern changed the WelcomeView navigation from Tone's original design. We need to:

1. **Revert to NavigationLink** (as Tone originally had)
2. **Change button text** to "Come in our Neighborhood"
3. **Navigate to Tour first** (not directly to SignUp)
4. **Tour then navigates to SignUp**

---

## Changes Required

### File: `WelcomeView.swift`

**Current Issues:**
- Uses Button with `showLoadingScreen` state
- Has LoadingView overlay
- Navigates directly to SignUpView

**Required Changes:**

#### 1. Remove Loading State

**Remove these state variables:**
```swift
// REMOVE:
@State private var showLoadingScreen = false
@State private var navigateToSignUp = false
```

**Keep only:**
```swift
@State private var navigateToLogin = false  // For "Log in" link
```

#### 2. Replace Button with NavigationLink

**Current (Broken):**
```swift
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
```

**New (Tone's Design):**
```swift
// MARK: - Tour Navigation
// NavigationLink to InteractiveTourView
// Text per Tone's requirement: "Come in our Neighborhood"
// Tour will then navigate to SignUpView
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
```

#### 3. Remove Loading Overlay

**Remove this section:**
```swift
// REMOVE ENTIRELY:
// Loading Overlay on Welcome Screen
if showLoadingScreen {
    LoadingView(mode: .welcome, isLoading: $showLoadingScreen) {
        navigateToSignUp = true
    }
    .transition(.opacity)
}
```

#### 4. Update Navigation Destinations

**Current:**
```swift
.navigationDestination(isPresented: $navigateToSignUp) {
    SignUpView()
}
.navigationDestination(isPresented: $navigateToLogin) {
    LoginView()
}
```

**New:**
```swift
// MARK: - Navigation Destinations
// Login navigation (for "Log in" link)
// SignUp navigation now happens from Tour, not directly here
.navigationDestination(isPresented: $navigateToLogin) {
    LoginView()
}
```

#### 5. Final WelcomeView Structure

```swift
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
struct WelcomeView: View {
    // MARK: - Navigation State
    // Only need login navigation (tour handles signup flow)
    @State private var navigateToLogin = false

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
                        // Tour then guides user to SignUp
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

                // MARK: - Navigation Destinations
                .navigationDestination(isPresented: $navigateToLogin) {
                    LoginView()
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AuthViewModel())
}
```

---

## Testing Checklist

- [ ] WelcomeView displays "Come in our Neighborhood" button
- [ ] Button uses NavigationLink (not Button)
- [ ] Tapping button navigates to InteractiveTourView
- [ ] No loading screen appears
- [ ] "Log in" link still works
- [ ] No compile errors
- [ ] Navigation flow: Welcome → Tour → (tour ends) → SignUp

---

## Notes for Interns

### Why NavigationLink?

```swift
// NavigationLink is the SwiftUI way to handle navigation
// It's declarative - you say "this goes here"
// SwiftUI handles the transition animation
// Better than manual state + sheet/presentation
```

### Why Remove Loading?

```swift
// The loading screen was added by AI, not in Tone's design
// Tour replaces the need for a loading screen
// Tour is the "loading" experience - shows value while preparing
```

---

## Authorization Required

**DO NOT PROCEED** without explicit approval from Tone King on:

1. [ ] WelcomeView changes above
2. [ ] "Come in our Neighborhood" exact text
3. [ ] Button styling (keep current or modify?)

---

*Document created: 2026-08-01*
*Author: Abraham (AI Assistant)*
*For: Community Hands Team*
