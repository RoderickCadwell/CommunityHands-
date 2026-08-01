# Phase 7: Apple Accessibility Feature

## Overview

**Objective:** Add accessibility feature for Apple Accessibility Contest.

**Priority:** High — Contest entry requirement

**Branch:** `feature/accessibility`

**Note:** Feature TBD on Monday (per Tone's instruction)

---

## Candidate Features

### Option 1: VoiceOver Support
**Implementation:** Add `.accessibilityLabel()` and `.accessibilityHint()` to all interactive elements.

```swift
Button("Get Started") { ... }
    .accessibilityLabel("Come in our Neighborhood")
    .accessibilityHint("Double tap to start the app tour")
```

**Pros:**
- Benefits blind/low-vision users
- Required for App Store approval
- Easy to implement
- Apple loves good VoiceOver support

---

### Option 2: Dynamic Type Support
**Implementation:** Ensure app scales with system font size.

```swift
// Use text styles instead of fixed sizes
Text("Title")
    .font(.headline) // Scales automatically

// NOT: .font(.system(size: 20))
```

**Pros:**
- Benefits users with vision impairments
- Required for good iOS app
- Shows understanding of iOS design

---

### Option 3: Reduce Motion
**Implementation:** Respect user preference for reduced animations.

```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

// Skip animations if user prefers
if !reduceMotion {
    withAnimation { ... }
}
```

**Pros:**
- Benefits users with motion sensitivity
- Shows attention to accessibility details
- Easy to implement

---

### Option 4: High Contrast Mode
**Implementation:** Add toggle for enhanced contrast.

```swift
// Alternative color scheme with higher contrast
// Toggle in Settings
```

---

## Implementation Plan

**Monday:** Tone confirms which feature with team
**Tuesday-Thursday:** Implement chosen feature
**Friday:** Test and refine

---

## Testing Checklist

- [ ] Feature works on device
- [ ] VoiceOver/other assistive tech works (if applicable)
- [ ] No visual regressions
- [ ] Document in README

---

*Phase 7: Apple Accessibility Feature — TBD Monday*
