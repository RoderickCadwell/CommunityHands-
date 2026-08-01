# UI Context

## Theme

Community Hands uses a clean, approachable design with green as the primary accent color. The design reflects the app's mission: growth, community, and positive action. The feel should be friendly, trustworthy, and accessible to both teens and homeowners.

---

## Colors

### Primary Palette

| Role            | Asset Name               | Hex Value   | Usage                                    |
| --------------- | ------------------------ | ----------- | ---------------------------------------- |
| Primary Green   | `primaryComHandColor`    | `#25960E`   | Main brand color, buttons, CTAs          |
| Secondary       | `secondaryComHandColor`  | (defined)   | Supporting accents, gradients            |
| Page Background | `systemBackground`       | System      | Main app background                      |
| Card Background | `secondarySystemBackground` | System   | Cards, elevated surfaces                 |

**Note:** Colors are defined in Assets.xcassets with light and dark mode support.

### Text Colors

| Role           | Asset Name       | Usage                         |
| -------------- | ---------------- | ----------------------------- |
| Primary text   | `.primary`       | Headlines, important text     |
| Secondary text | `.secondary`     | Subtitles, descriptions       |
| Tertiary text  | `.gray`          | Placeholders, hints           |
| Inverted text  | `.white`         | Text on green/colored surfaces |

---

## Typography

Community Hands uses the San Francisco font family (system fonts) for native iOS feel.

| Role         | Font Style       | Size | Weight     | Usage                          |
| ------------ | ---------------- | ---- | ---------- | ------------------------------ |
| App Title    | `.largeTitle`    | 34pt | Bold       | "Community Hands" branding     |
| Title 1      | `.title`         | 28pt | Bold       | Screen titles                  |
| Title 2      | `.title2`        | 22pt | Bold       | Section headers                |
| Title 3      | `.title3`        | 20pt | Semibold   | Card titles                    |
| Headline     | `.headline`      | 17pt | Semibold   | List item titles               |
| Body         | `.body`          | 17pt | Regular    | Primary content text           |
| Callout      | `.callout`       | 16pt | Regular    | Secondary content              |
| Subheadline  | `.subheadline`   | 15pt | Regular    | Captions, metadata             |
| Footnote     | `.footnote`      | 13pt | Regular    | Timestamps, small labels       |
| Caption      | `.caption`       | 12pt | Regular    | Fine print, hints              |

---

## Border Radius

| Context        | Radius | Usage                              |
| -------------- | ------ | ---------------------------------- |
| Cards          | 12-16pt| Main cards                         |
| Buttons        | 8-14pt | Primary and secondary buttons      |
| Input fields   | 8pt    | Text fields, pickers               |
| Small elements | 6pt    | Tags, badges                       |

---

## Spacing

| Token           | Value | Usage                           |
| --------------- | ----- | ------------------------------- |
| `spacingXS`     | 4pt   | Tight internal spacing          |
| `spacingSmall`  | 8pt   | Icon padding, small gaps        |
| `spacingMedium` | 16pt  | Standard padding, card margins  |
| `spacingLarge`  | 24pt  | Section spacing                 |
| `spacingXL`     | 32pt  | Major section dividers          |

---

## Component Library

### Buttons

**Primary Button (Green CTA)**
```swift
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
```

**Secondary Button**
- Text-only or bordered style
- Green text for links

**Icon Button**
- Size: 44x44pt minimum (touch target)
- SF Symbol icons

### Input Fields

**Text Field**
```swift
TextField("Enter email or phone number", text: $emailOrPhone)
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(8)
    .overlay(
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.black, lineWidth: 1)
    )
```

### Cards

**Job Card**
- Background: `secondarySystemBackground`
- Corner radius: 12pt
- Padding: 16pt
- Shadow: subtle

### Loading Screen

Already implemented in `loadingview.swift`:
- Green circular indicator
- Animated bounce effect
- Dynamic progress messages
- Mode-based icons (welcome, login, signUp, etc.)

---

## Layout Patterns

### Welcome Screen
- Centered logo
- App title in primary green
- Spacing: 45pt between major elements
- CTA buttons at bottom

### Auth Flow
- Two-step process (contact info → identity verification)
- Loading screen between steps
- Back button navigation

### Terms & Waiver
- Scrollable legal text
- Section headers with bold titles
- Signature fields at bottom
- Checkbox for agreement
- Fixed bottom button area

### Main Menu (Homeowner)
- Map view background (mock or real)
- Status banner at top
- Job/Action cards
- Bottom navigation bar

### Job Listings
- Search bar at top
- Category filter pills (horizontal scroll)
- Scrollable job cards
- Rating display with stars

---

## Icons (SF Symbols)

| Purpose            | Symbol Name                  | Style   |
| ------------------ | ---------------------------- | ------- |
| Hand/Community     | `hand.raised.hands.fill`     | Fill    |
| Shield/Security    | `shield.checkmark`           | Regular |
| Person             | `person.crop.circle.fill`    | Fill    |
| Calendar           | `calendar.badge.clock`       | Fill    |
| Search             | `magnifyingglass`            | Regular |
| Location           | `mappin.and.ellipse`         | Regular |
| Star/Rating        | `star.fill`                  | Fill    |
| Check/Done         | `checkmark.circle.fill`      | Fill    |
| Document           | `doc.text.fill`              | Fill    |
| Photo/Upload       | `photo`                      | Regular |
| Chevron/Back       | `chevron.left`               | Regular |
| Close              | `xmark`                      | Regular |

---

## Animations

- Loading view uses `Animation.easeInOut` with bounce effect
- Screen transitions use `.transition(.opacity)`
- Navigation uses SwiftUI default animations
- Keep animations subtle and purposeful

---

## Accessibility

- Minimum touch target: 44x44pt
- Dynamic Type support (use `.font()` with text styles)
- Sufficient color contrast
- VoiceOver labels on interactive elements

---

## Current UI Status

**Implemented:**
- ✅ WelcomeView with branding
- ✅ LoadingView with animations
- ✅ SignUpView (2-step)
- ✅ LoginView (2-step)
- ✅ TermsAndPoliciesView with legal text
- ✅ CustomerBioView with role picker
- ✅ MainMenuView with map mock
- ✅ JobListingsView with search and filter

**Notes:**
- WelcomeView has Tone's original design (do not redesign)
- LoadingView has comprehensive animation system
- Terms view has full legal text with signature capture

---

*Community Hands — UI Context*
