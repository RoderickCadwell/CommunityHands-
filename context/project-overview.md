# Community Hands

## Overview

Community Hands is an iOS application designed to connect **teenagers seeking work experience** with **homeowners needing assistance** with everyday tasks. The app serves as a two-sided marketplace where teens can earn income while building skills, and homeowners can get help with tasks like lawn care, pet care, babysitting, car washing, and tutoring.

**Target Audience:** 
- **Teens (Helpers):** Ages 14-19 seeking part-time work and experience
- **Homeowners (Customers):** Adults needing reliable help with household tasks

**Revenue Model:** Commission on completed jobs (customer/teen side is revenue-generating)

---

## The Problem

Teens are able to work but lack the experience required to gain traditional employment. They need:
- Flexible work that fits school schedules
- Opportunities to build skills and references
- Safe, local opportunities
- A way to earn income while preparing for adulthood

Homeowners need:
- Affordable help with routine tasks
- Reliable local workers
- An alternative to expensive professional services

---

## Solution

Community Hands provides a **two-sided marketplace** where:

### For Homeowners (Customer/Client Side) 💰
- **Required: Background check verification** (for teen worker safety)
- Post jobs with descriptions and pricing
- Browse teen helpers and their ratings
- Request services (lawn care, pet care, babysitting, car wash, tutoring)
- Pay securely through the platform
- Rate and review completed work

### For Teens (Helper Side)
- Create profiles with skills and availability
- Browse available jobs in their neighborhood
- Accept jobs that match their skills
- Get paid through the platform
- Build ratings and reviews for future opportunities

---

## Core User Flow

### Homeowner Flow (Priority)
1. Homeowner opens app and sees Welcome/Login
2. Creates account or logs in
3. Completes Terms & Waiver (electronic signature)
4. Completes bio/profile
5. Enters marketplace (Main Menu)
6. Can:
   - Post a job (create job listing)
   - Browse available teen helpers
   - View active/past jobs
   - Rate completed work

### Teen Helper Flow
1. Teen opens app and sees Welcome/Login
2. Creates account or logs in
3. Completes Terms & Waiver
4. Completes bio/profile with skills
5. Enters marketplace
6. Can:
   - Browse available jobs
   - Accept jobs
   - View schedule
   - Track earnings
   - Rate homeowners

---

## Features

### MVP Features (In Scope)

#### Authentication & Onboarding
- Welcome screen with branding
- Sign up (email/phone + ID verification)
- Login (existing users)
- Terms & Waiver with electronic signature
- **Homeowner background check verification** (safety requirement)
- Bio/profile completion
- SwiftData persistence for user data
- **Apple Accessibility Feature** (TBD - placeholder for contest entry)
- **Interactive Demo Tour** — Pre-filled walkthrough for pitch presentations

#### Homeowner (Customer) Features - PRIORITY
- **Job Creation:** Post jobs with title, category, description, price
- **Helper Browser:** View teen profiles, ratings, skills
- **My Jobs:** Track active and completed jobs
- **Payment Integration:** Secure checkout (simulated for MVP)
- **Ratings:** Rate and review helpers

#### Teen (Helper) Features
- **Job Browser:** View available jobs by category
- **Job Acceptance:** Accept jobs, see details
- **Schedule:** View upcoming scheduled work
- **Earnings Tracking:** See completed jobs and earnings
- **Ratings:** Build reputation through reviews

#### Marketplace
- Category filtering (Lawn Care, Pet Care, Babysitting, Car Wash, Tutoring)
- Search functionality
- Job cards with details
- Rating display (stars)

### Future Features (Post-MVP)

The following features are planned for future builds:

#### In-App Messaging
- Direct communication between homeowners and teens
- Job coordination
- Safety check-ins

#### Real-Time Notifications
- Push notifications for new jobs
- Job acceptance confirmations
- Payment confirmations
- Schedule reminders

#### Enhanced Background Checks
- Integration with background check services
- Verification badges for homeowners
- Continuous monitoring

#### Advanced Scheduling
- Calendar integration
- Recurring jobs (weekly lawn care, etc.)
- Availability settings

#### Payment Improvements
- Multiple payment methods
- Tip functionality
- Instant payout for teens

---

## Scope

### In Scope

- User authentication (email/phone + ID verification)
- Terms & Waiver with electronic signatures
- User profiles (bio, role selection)
- Job posting (homeowners)
- Job browsing and acceptance (teens)
- Category filtering and search
- Rating and review system
- SwiftData persistence for all data
- Loading animations and transitions
- Clean UI matching Community Hands branding
- **Interactive Demo Tour** — For pitch presentations (pre-filled data, guided walkthrough)

### Out of Scope (Future)

- Cloud sync (iCloud, etc.)
- Push notifications
- Real-time messaging
- Background check integration
- Advanced payment processing
- In-app calendar integration
- Widget extensions
- Apple Watch app
- Multiple user accounts per device

---

## Success Criteria

### Homeowner (Customer) Side
1. Homeowner can create account and complete onboarding
2. Homeowner can post a job with category, description, and price
3. Homeowner can browse teen helpers and view ratings
4. Homeowner can request/book a service
5. Homeowner can rate and review completed work
6. All data persists using SwiftData

### Teen (Helper) Side
1. Teen can create account and complete onboarding
2. Teen can browse available jobs by category
3. Teen can accept a job and see details
4. Teen can view their schedule of accepted jobs
5. Teen can see earnings from completed work
6. All data persists using SwiftData

### Technical
7. App passes build verification with no errors
8. UI follows Community Hands design guidelines
9. App runs on iOS 17+ devices

---

## Color Scheme

**Primary Brand Color:** `#25960E` (Green - primaryComHandColor)
**Secondary Color:** (secondaryComHandColor in Assets)

Green represents growth, community, and positive action — fitting for a platform about helping and earning.

---

## Design Notes

- Clean, modern UI with green accent color
- SF Symbols for icons
- Card-based layouts
- Loading screens with animations (already implemented)
- Electronic signature flow for Terms & Waiver
- Role selection in profile (Community Member, Volunteer, Local Vendor)

---

## Data Persistence

**All data stored locally using SwiftData:**
- User profiles
- Job postings
- Accepted jobs
- Ratings and reviews
- Terms acceptance records

No external cloud storage for MVP — everything is device-local.

---

## Safety & Legal

- Comprehensive Terms & Waiver covering liability
- Parental consent for users under 18
- Electronic signature capture
- Clear disclosure that Community Hands is only a marketplace (not employer)
- Safety guidelines included in Terms

---

## Team

- **Product Manager:** Roderick (JOURNi Student)
- **Development Team:** Community Hands Team
- **Instructor:** Tone King
- **Program:** NAF Intern Cohort by JOURNi

---

*Community Hands — WORK. LEARN. EARN. GROW.*
