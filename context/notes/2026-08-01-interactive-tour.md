# Interactive Demo Tour Feature

**Date:** 2026-08-01
**Requested by:** Tone King
**Purpose:** Pitch presentation enhancement

---

## Overview

Add an interactive demo tour mode to Community Hands for pitch presentations. This allows the team to demonstrate the full app flow without typing or delays during the presentation.

---

## Requirements

### Must Have
- Pre-filled sample data (user accounts, jobs, etc.)
- Guided walkthrough highlighting key features
- Quick access (hidden gesture or button)
- Smooth transitions between demo steps
- Resets cleanly after tour

### Nice to Have
- Multiple demo scenarios (Homeowner flow, Teen flow)
- Auto-play mode (hands-free demo)
- Pause/resume capability
- Demo progress indicator

---

## Implementation Ideas

### Option 1: Demo Mode Flag
```swift
@AppStorage("isDemoMode") var isDemoMode: Bool = false

// In views:
if isDemoMode {
    // Use sample data
    emailOrPhone = "demo@example.com"
    fullName = "Demo User"
}
```

### Option 2: Demo Data Service
```swift
class DemoDataService {
    static func populateSampleData() {
        // Create sample user
        // Create sample jobs
        // Set flags to skip onboarding
    }
}
```

### Option 3: Tour Overlay
- Semi-transparent overlay with arrows
- Highlights buttons/actions
- Step-by-step guided tour

---

## Access Method Ideas

1. **Secret Gesture:** Tap logo 5 times rapidly
2. **Debug Menu:** Shake device to show hidden menu
3. **Settings Toggle:** Hidden in Settings for demo builds
4. **Launch Argument:** Detect "--demo" in launch args

---

## Demo Flow (Homeowner Side)

1. SplashScreen (normal)
2. WelcomeView → Tap "Get Started"
3. SignUpView → Pre-filled, tap "Next"
4. TermsView → Auto-scroll, pre-checked, tap "Accept"
5. BioView → Pre-filled, tap "Save"
6. MainMenuView → "Finding work..." status
7. JobListingsView → Show sample jobs
8. PurchaseService → Complete demo flow

**Total time:** ~45 seconds vs 3+ minutes with typing

---

## When to Implement

**Phase:** After Phase 2 (SwiftData Models) or Phase 3 (Homeowner Flow)

**Priority:** Medium-High — Needed for pitch day (August 11th)

---

*Document created for Community Hands pitch preparation*
