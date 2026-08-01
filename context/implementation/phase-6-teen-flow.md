# Phase 6: Teen (Helper) Flow

## Overview

**Objective:** Complete helper-side features for teens.

**Priority:** Medium — Secondary to Customer flow

**Branch:** `feature/teen-flow`

---

## Problem Statement

Teens need to:
- Browse available jobs in their area
- Accept jobs they want to do
- View their schedule of accepted jobs
- Track earnings from completed work

---

## Views to Create/Update

### 1. ScheduleView
```swift
struct ScheduleView: View {
    @Query(filter: \.teenId == currentUserId) var myJobs: [AcceptedJob]
    
    // Calendar-style view of accepted jobs
    // Shows upcoming and past jobs
}
```

### 2. EarningsView
```swift
struct EarningsView: View {
    @Query(filter: \.teenId == currentUserId) var completedJobs: [AcceptedJob]
    
    // Total earnings display
    // List of completed jobs with payouts
    // Earnings history
}
```

### 3. Update JobListingsView
- Already exists but needs teen-facing improvements
- "Accept Job" flow refinement
- Show distance, homeowner rating

---

## Testing Checklist

- [ ] Teen can browse available jobs
- [ ] Teen can accept a job
- [ ] Accepted job appears in Schedule
- [ ] Completed jobs show in Earnings
- [ ] Earnings calculate correctly

---

*Phase 6: Teen (Helper) Flow*
