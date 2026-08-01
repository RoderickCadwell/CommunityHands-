# Phase 2: Interactive Demo Tour

## Overview

**Objective:** Create an interactive demo tour for pitch presentations that showcases the app flow without typing.

**Priority:** High — Needed for August 11th pitch day

**Branch:** `feature/interactive-tour` (to be created)

---

## Problem Statement

During pitch presentations, the team needs to demonstrate the app quickly without:
- Typing email/phone numbers
- Filling out forms manually
- Waiting for loading screens
- Explaining each step verbally

A demo tour with pre-filled data will:
1. Show the full flow in ~45 seconds
2. Impress investors with smooth, professional presentation
3. Allow presenters to focus on speaking, not typing

---

## New Navigation Flow (Per Tone's Requirements)

```
WelcomeView
└── "Come in our Neighborhood" button (NavigationLink)
    └── InteractiveTourView
        └── Demo walkthrough with pre-filled data
            └── SignUpView (at tour completion)
                └── Existing auth flow continues...
```

---

## Changes Required

### File 1: Create `InteractiveTourView.swift`

**Location:** `Community Hands/Views/Onboarding/InteractiveTourView.swift`

**Purpose:** Guided walkthrough showing app features with pre-filled data

**Requirements:**
- Full-screen overlay or dedicated view
- Step-by-step progression through app features
- Pre-filled sample data (no typing required)
- Highlight key UI elements with callouts
- Smooth animations between steps
- Skip option to go straight to SignUp
- Progress indicator

**Tour Steps (Homeowner Flow Demo):**

1. **Welcome Screen** (static showcase)
   - "This is Community Hands"
   - "A marketplace connecting teens & homeowners"

2. **Tour SignUp** (pre-filled)
   - Email: `demo@communityhands.app`
   - Phone: `555-DEMO-001`
   - Auto-advances after 2 seconds

3. **Tour Identity Verification** (pre-filled)
   - Name: "Demo Homeowner"
   - ID: Pre-verified state
   - Auto-advances

4. **Tour Terms & Waiver** (pre-accepted)
   - Shows signature fields
   - "In demo mode, we skip the legal paperwork"
   - Auto-advances

5. **Tour Bio Completion** (pre-filled)
   - Role: "Community Member"
   - Bio: "Looking for reliable help with home tasks"
   - Auto-advances

6. **Tour Main Menu** (mock active state)
   - Shows "Finding work..." banner
   - Sample job card visible
   - "Homeowners can browse teen helpers here"

7. **Tour Marketplace** (sample data)
   - Shows sample job listings
   - "Browse services: Lawn Care, Pet Care, etc."
   - Tap on sample job

8. **Tour Complete**
   - "Ready to create your account?"
   - Button: "Start Real Sign Up" → SignUpView

**Code Structure:**
```swift
import SwiftUI

// MARK: - Interactive Tour View
// Guided demo walkthrough for pitch presentations
// Pre-filled data allows smooth, fast demo without typing
struct InteractiveTourView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var currentStep: TourStep = .welcome
    @State private var isAnimating = false
    
    enum TourStep: Int, CaseIterable {
        case welcome = 0
        case signUp
        case identity
        case terms
        case bio
        case mainMenu
        case marketplace
        case complete
        
        var title: String {
            switch self {
            case .welcome: return "Welcome to Community Hands"
            case .signUp: return "Quick Account Setup"
            case .identity: return "Verify Your Identity"
            case .terms: return "Review Terms"
            case .bio: return "Complete Your Profile"
            case .mainMenu: return "Find Help"
            case .marketplace: return "Browse Services"
            case .complete: return "Ready to Get Started?"
            }
        }
        
        var description: String {
            switch self {
            case .welcome: 
                return "A marketplace connecting teens with homeowners who need help."
            case .signUp:
                return "Sign up with email or phone. In demo mode, we auto-fill this."
            // ... etc
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background based on current step
            stepBackground
            
            VStack {
                // Progress indicator
                TourProgressBar(currentStep: currentStep.rawValue, totalSteps: TourStep.allCases.count)
                
                Spacer()
                
                // Current step content
                currentStepContent
                
                Spacer()
                
                // Navigation buttons
                tourNavigationButtons
            }
            .padding()
        }
    }
    
    // Step content rendering...
}

// MARK: - Tour Progress Bar
struct TourProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)
                
                // Progress fill
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("primaryComHandColor"))
                    .frame(width: geometry.size.width * (CGFloat(currentStep + 1) / CGFloat(totalSteps)), height: 8)
            }
        }
        .frame(height: 8)
    }
}
```

---

### File 2: Update `WelcomeView.swift`

**Change:** Replace "Get Started" button with NavigationLink

**Current:**
```swift
// Button for Get Started (Triggers Loading Animation)
Button(action: {
    withAnimation {
        showLoadingScreen = true
    }
}) {
    Text("Get Started")
        .font(.system(size: 20, weight: .semibold))
        // ... styling
}
```

**New:**
```swift
// MARK: - Tour Navigation
// NavigationLink to InteractiveTour instead of direct SignUp
// Text changed per Tone's requirement: "Come in our Neighborhood"
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

**Remove:**
- `showLoadingScreen` state (no longer needed)
- Loading overlay on WelcomeView
- `navigateToSignUp` state (handled by Tour)

---

## Demo Data

**Sample User (Homeowner):**
```swift
let demoUser = DemoUser(
    email: "demo.homeowner@communityhands.app",
    phone: "555-DEMO-001",
    fullName: "Sarah Johnson",
    idType: "Driver's License",
    role: "Community Member",
    bio: "Working parent looking for reliable help with yard work and pet care."
)
```

**Sample Jobs:**
```swift
let demoJobs = [
    DemoJob(title: "Lawn Mowing", category: "Lawn Care", price: 35.00),
    DemoJob(title: "Dog Walking", category: "Pet Care", price: 20.00),
    DemoJob(title: "Babysitting", category: "Child Care", price: 15.00)
]
```

---

## Access Method

**For Pitch:** Always show Tour by default (hardcoded)
**For Production:** Hidden toggle (tap logo 5 times)

---

## Testing Checklist

- [ ] WelcomeView shows "Come in our Neighborhood" button
- [ ] Tapping button navigates to InteractiveTourView
- [ ] Tour progresses through all 8 steps automatically or via tap
- [ ] Each step shows pre-filled data (no typing)
- [ ] Progress bar advances correctly
- [ ] Skip button available on each step
- [ ] Final step has "Start Real Sign Up" → SignUpView
- [ ] SignUpView receives handoff correctly
- [ ] Total demo time: ~45 seconds

---

## Notes for Interns

### Why a Tour?

```swift
// During presentations, typing slows everything down
// A tour with pre-filled data shows the app at its best
// Investors see the full flow without waiting
```

### NavigationLink vs Button

```swift
// Button: Requires manual state management for navigation
// NavigationLink: Declarative, SwiftUI handles the transition
// We use NavigationLink for cleaner code
```

---

## Authorization Required

**DO NOT PROCEED** without explicit approval from Tone King on:

1. [ ] Tour step content and flow
2. [ ] "Come in our Neighborhood" button text
3. [ ] Tour → SignUp handoff method
4. [ ] Demo data content

---

*Document created: 2026-08-01*
*Author: Abraham (AI Assistant)*
*For: Community Hands Team — Pitch Day Prep*
