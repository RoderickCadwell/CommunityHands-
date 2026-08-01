# Phase 1: Add Splash Screen

## Overview

**Objective:** Add a Splash Screen as the entry point that shows an animation, then transitions to WelcomeView.

**Priority:** Critical - App needs branded splash experience before WelcomeView

**Branch:** `fix/add-splash-screen` (to be created after approval)

---

## Problem Statement

The current app has three critical architectural issues preventing proper user flow:

1. **Wrong Entry Point:** `Community_HandsApp.swift` launches `WelcomeView` directly instead of `RootView`
2. **Multiple AuthViewModels:** Several views create their own `@StateObject var authViewModel = AuthViewModel()`
3. **Conflicting Navigation:** `WelcomeView` has its own `NavigationStack` that duplicates `RootView` logic

---

## Changes Required

### File 1: `Community_HandsApp.swift`

**Current (Broken):**
```swift
@main
struct Cummunity_HandsApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            WelcomeView()  // ❌ Wrong entry point
                .environmentObject(authViewModel)
        }
    }
}
```

**Fix:**
```swift
// MARK: - App Entry Point
// Uses RootView to handle all auth state routing
// RootView decides: Welcome -> Terms -> Bio -> MainMenu
@main
struct Cummunity_HandsApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()  // ✅ Centralized navigation
                .environmentObject(authViewModel)
        }
    }
}
```

---

### File 2: `ContentView.swift`

**Current (Broken):**
```swift
struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()  // ❌ Duplicate instance

    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                // ...
            }
        }
        .environmentObject(authViewModel)  // ❌ Overwrites parent's instance
    }
}
```

**Fix:**
```swift
// MARK: - ContentView
// Uses shared AuthViewModel from environment
// Note: This view appears to be unused - RootView handles navigation
struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel  // ✅ Single shared instance

    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                // Content for logged-in users
                VStack(spacing: 20) {
                    Text("Hello, \(authViewModel.userFullName.isEmpty ? "User" : authViewModel.userFullName)!")
                        .font(.title)
                        .bold()
                    
                    Text("Contact: \(authViewModel.userEmailOrPhone)")
                        .foregroundColor(.gray)
                    
                    Button("Log Out") {
                        authViewModel.logOut()
                    }
                    .padding()
                    .foregroundColor(.red)
                }
            } else {
                AuthView()
            }
        }
    }
}
```

---

### File 3: `WelcomeView.swift`

**Current (Problematic):**
- Has its own `NavigationStack`
- Manages `showLoadingScreen` state
- Directly navigates to `SignUpView` and `LoginView`

**Analysis:**
`RootView` already has the navigation logic:
```swift
RootView.swift:
- isAuthenticated == false → WelcomeView
- isAuthenticated == true, hasCompletedOnboarding == false → TermsAndPoliciesView
- isAuthenticated == true, hasCompletedOnboarding == true → MainMenuView
```

**Required Changes:**
1. Remove `NavigationStack` wrapper (RootView handles navigation)
2. Change button actions to update `AuthViewModel` state
3. Let `RootView` handle the transitions

**Fix (WelcomeView body only):**
```swift
// MARK: - WelcomeView
// Entry point for unauthenticated users
// Note: No NavigationStack - RootView handles navigation
struct WelcomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLoadingScreen = false

    var body: some View {
        // Removed NavigationStack - RootView provides navigation
        ZStack {
            VStack(spacing: 45) {
                // ... existing branding code ...
                
                // CTA Buttons
                VStack {
                    // Get Started triggers loading, then goes to SignUp
                    Button(action: {
                        withAnimation {
                            showLoadingScreen = true
                        }
                    }) {
                        Text("Get Started")
                            // ... styling ...
                    }
                    
                    // Log In button
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                        Button(action: {
                            // Signal to RootView that we want Login
                            // This requires adding a state to AuthViewModel
                        }) {
                            Text("Log in")
                        }
                    }
                }
            }
            
            // Loading Overlay
            if showLoadingScreen {
                LoadingView(mode: .welcome, isLoading: $showLoadingScreen) {
                    // Transition to authentication flow
                    // Need to signal RootView to show SignUp
                }
            }
        }
    }
}
```

**Note:** This requires adding state to `AuthViewModel` to track whether user wants SignUp vs Login.

---

## Additional Changes Needed

### File 4: `AuthViewModel.swift`

Add state to track onboarding path:

```swift
// MARK: - AuthViewModel
// Centralized authentication state management
// Single source of truth for entire app
@MainActor
class AuthViewModel: ObservableObject {
    // MARK: - Persistent App Storage Properties
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    // MARK: - Navigation State
    @Published var isAuthenticated: Bool = false
    @Published var authDestination: AuthDestination = .welcome  // NEW
    
    // ... existing properties ...
}

// NEW: Enum for auth flow destinations
enum AuthDestination {
    case welcome
    case signUp
    case login
    case terms
    case bio
    case mainMenu
}
```

---

## Implementation Steps

1. **Create branch:** `fix/customer-flow-auth`
2. **Fix Community_HandsApp.swift:** Change entry point to RootView
3. **Fix ContentView.swift:** Change to @EnvironmentObject
4. **Update AuthViewModel:** Add authDestination state
5. **Update WelcomeView:** Remove NavigationStack, use environment object
6. **Update RootView:** Handle authDestination routing
7. **Test:** Verify auth flow works end-to-end

---

## Testing Checklist

- [ ] App launches to WelcomeView
- [ ] "Get Started" → Loading → SignUp → Terms → Bio → MainMenu
- [ ] "Log in" → Loading → Login → MainMenu (skips Terms/Bio for existing users)
- [ ] Single AuthViewModel instance throughout
- [ ] No duplicate NavigationStacks
- [ ] State persists across app restarts (@AppStorage)

---

## Notes for Interns

### Why These Changes Matter

**1. Single Source of Truth:**
```swift
// BAD: Multiple instances = different data
@StateObject var authViewModel = AuthViewModel()  // View A
@StateObject var authViewModel = AuthViewModel()  // View B (different instance!)

// GOOD: Shared instance
@EnvironmentObject var authViewModel: AuthViewModel  // Same instance everywhere
```

**2. Centralized Navigation:**
```swift
// RootView acts as the router - decides what to show based on state
// This is the "Coordinator" pattern in SwiftUI
```

**3. Separation of Concerns:**
```swift
// Views should only handle display
// ViewModels handle business logic
// RootView handles navigation decisions
```

---

## Authorization Required

**DO NOT PROCEED** without explicit approval from Tone King on:

1. [ ] This implementation plan
2. [ ] Branch name: `fix/customer-flow-auth`
3. [ ] Priority of fixes (which files first)
4. [ ] Whether to also fix WelcomeView design (per Tone's original) or just structural issues

---

*Document created: 2026-08-01*
*Author: Abraham (AI Assistant)*
*For: Community Hands Team*
