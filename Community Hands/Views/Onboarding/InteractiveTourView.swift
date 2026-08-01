//
//  InteractiveTourView.swift
//  Community Hands
//
//  Created by JOURNi Student on 8/1/26.
//

import SwiftUI

// MARK: - Interactive Tour View
// Guided demo walkthrough for pitch presentations
// Pre-filled data allows smooth, fast demo without typing
// Homeowner-centric flow: shows revenue side first
struct InteractiveTourView: View {
    // MARK: - Environment
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion // Accessibility: respect user motion preferences
    
    // MARK: - Tour State
    @State private var currentStep: TourStep = .welcome
    @State private var showSignUp = false
    @State private var autoAdvanceTask: Task<Void, Never>?
    
    // MARK: - Demo Data
    // Homeowner-focused data for pitch presentations
    private let demoHomeowner = DemoHomeowner(
        email: "sarah.johnson@email.com",
        phone: "(313) 555-0198",
        fullName: "Sarah Johnson",
        idType: "Driver's License",
        idNumber: "MI-DL-9876543",
        address: "Oak Park, MI",
        householdSize: "Family of 4",
        avatarInitials: "SJ",
        bio: "Working mom with two kids and a golden retriever. Need help keeping up with yard work and occasional babysitting.",
        backgroundCheckStatus: "Verified",
        jobTitle: "Lawn Care Needed",
        jobDescription: "Front and back yard mowing, edging around driveway and walkways. About 1/4 acre total. Prefer weekend mornings.",
        jobBudget: 45.00,
        jobCategory: "Lawn Care"
    )
    
    private let demoTeen = DemoTeen(
        name: "Marcus Williams",
        age: 17,
        school: "Cass Tech High School",
        skills: ["Lawn Care", "Dog Walking", "Basic Repairs"],
        rating: 4.8,
        jobsCompleted: 23,
        initials: "MW"
    )
    
    // Locale-aware currency formatter
    private var priceFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }
    
    // MARK: - Tour Steps
    // Homeowner-centric flow for pitch presentations
    // Shows revenue side first: homeowner posts job, teen accepts
    enum TourStep: Int, CaseIterable {
        case welcome = 0
        case homeownerProfile      // Avatar + demographics
        case homeownerSignUp     // Sign up as homeowner
        case homeownerIdentity   // ID verification
        case homeownerTerms      // Background check emphasis
        case createJob           // Homeowner posts job request
        case jobPosted           // Job appears in marketplace
        case teenAccepts         // Teen sees and accepts job
        case matchMade           // Connection established
        case complete            // Final CTA
        
        // Total number of steps for progress calculation
        static var count: Int { allCases.count }
        
        // Display title for each step
        var title: String {
            switch self {
            case .welcome:
                return "Welcome to Community Hands"
            case .homeownerProfile:
                return "Your Homeowner Profile"
            case .homeownerSignUp:
                return "Create Your Account"
            case .homeownerIdentity:
                return "Verify Your Identity"
            case .homeownerTerms:
                return "Safety First"
            case .createJob:
                return "Post a Job"
            case .jobPosted:
                return "Job Live in Marketplace"
            case .teenAccepts:
                return "Teen Helper Accepts"
            case .matchMade:
                return "Connection Made!"
            case .complete:
                return "Ready to Get Started?"
            }
        }
        
        // Description text explaining each step
        var description: String {
            switch self {
            case .welcome:
                return "A marketplace connecting homeowners with reliable teen helpers in your neighborhood."
            case .homeownerProfile:
                return "Add your profile picture and tell us about your household. This helps teens know who they're helping."
            case .homeownerSignUp:
                return "Create your free homeowner account. No fees to post jobs—only pay when work is completed."
            case .homeownerIdentity:
                return "Verify your identity with a driver's license or state ID. Your safety and trust are our priority."
            case .homeownerTerms:
                return "We require background checks for all homeowners. This protects our teen helpers and builds community trust."
            case .createJob:
                return "Describe what you need help with. Set your budget and preferred timing. It's that simple."
            case .jobPosted:
                return "Your job is now visible to verified teen helpers in your area. They can view details and apply."
            case .teenAccepts:
                return "Local teens see your job, check your profile, and accept if it's a good match for their skills."
            case .matchMade:
                return "You're connected! Schedule the work, communicate through the app, and pay securely when complete."
            case .complete:
                return "You've seen how easy it is to get help. Ready to post your first job?"
            }
        }
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                // Main content
                VStack(spacing: 0) {
                    // MARK: - Header
                    headerView
                    
                    // MARK: - Progress Bar
                    TourProgressBar(currentStep: currentStep.rawValue, totalSteps: TourStep.count)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    // MARK: - Step Content
                    ScrollView {
                        VStack(spacing: 24) {
                            currentStepContent
                                .padding(.horizontal)
                                .padding(.top, 20)
                        }
                    }
                    
                    Spacer()
                    
                    // MARK: - Navigation Buttons
                    navigationButtons
                        .padding()
                        .background(Color(.systemBackground))
                }
                // Auto-advance scheduling: runs on appear and when step changes
                .onAppear { scheduleAutoAdvance() }
                .onChange(of: currentStep) { _, _ in scheduleAutoAdvance() }
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Button(action: skipTour) {
                Text("Skip Tour")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("Demo Mode")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color("primaryComHandColor"))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color("primaryComHandColor").opacity(0.1))
                )
            
            Spacer()
            
            Button(action: skipTour) {
                Text("Skip")
                    .font(.subheadline)
                    .foregroundColor(.clear)
            }
            .disabled(true)
            .opacity(0)
        }
        .padding(.horizontal)
        .padding(.top, 16)
    }
    
    // MARK: - Step Content
    // Homeowner-centric flow: profile -> signup -> ID -> terms -> post job -> match -> complete
    @ViewBuilder
    private var currentStepContent: some View {
        switch currentStep {
        case .welcome:
            welcomeStepView
        case .homeownerProfile:
            homeownerProfileStepView
        case .homeownerSignUp:
            homeownerSignUpStepView
        case .homeownerIdentity:
            homeownerIdentityStepView
        case .homeownerTerms:
            homeownerTermsStepView
        case .createJob:
            createJobStepView
        case .jobPosted:
            jobPostedStepView
        case .teenAccepts:
            teenAcceptsStepView
        case .matchMade:
            matchMadeStepView
        case .complete:
            completeStepView
        }
    }
    
    // MARK: - Step 1: Welcome
    private var welcomeStepView: some View {
        VStack(spacing: 32) {
            // App icon
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .accessibilityLabel("Community Hands app icon")
            
            // Title and description
            VStack(spacing: 12) {
                Text(TourStep.welcome.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)
                
                Text(TourStep.welcome.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Community connection visual - Homeowner focused
            VStack(spacing: 16) {
                HStack(spacing: 40) {
                    VStack(spacing: 8) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                            .accessibilityHidden(true)
                        Text("Homeowners")
                            .font(.caption)
                            .fontWeight(.medium)
                        Text("Post Jobs")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Homeowners post jobs")
                    
                    // Handshake emoji showing connection between homeowners and teens
                    Text("🫱🏾‍🫲🏿")
                        .font(.system(size: 40))
                    
                    VStack(spacing: 8) {
                        Image(systemName: "person.fill.checkmark")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                        Text("Teens")
                            .font(.caption)
                            .fontWeight(.medium)
                        Text("Get Hired")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text("How it works")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
            .padding(.top, 20)
        }
    }
    
    // MARK: - Step 2: Homeowner Profile
    // Shows avatar, demographics, and household info
    private var homeownerProfileStepView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(TourStep.homeownerProfile.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(TourStep.homeownerProfile.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Profile card
            VStack(spacing: 16) {
                // Avatar - real image
                Image("sarah-johnson")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .accessibilityHidden(true) // Name is shown below, no need for VoiceOver to announce filename
                
                // Name and location
                VStack(spacing: 4) {
                    Text(demoHomeowner.fullName)
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "mappin")
                            .font(.caption)
                        Text(demoHomeowner.address)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
                
                // Demographics
                HStack(spacing: 20) {
                    VStack(spacing: 4) {
                        Image(systemName: "person.2")
                            .font(.title3)
                        Text(demoHomeowner.householdSize)
                            .font(.caption2)
                    }
                    .foregroundColor(.secondary)
                }
                .padding(.top, 8)
                
                Divider()
                
                // Bio preview
                Text(demoHomeowner.bio)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .padding(.top, 20)
            
            demoBadge(text: "Homeowner profile")
        }
    }
    
    // MARK: - Step 3: Homeowner Sign Up
    private var homeownerSignUpStepView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(TourStep.homeownerSignUp.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(TourStep.homeownerSignUp.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                TourFormField(label: "Email", value: demoHomeowner.email)
                TourFormField(label: "Phone", value: demoHomeowner.phone)
                TourFormField(label: "Account Type", value: "Homeowner")
            }
            .padding(.top, 20)
            
            // Value prop
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color("primaryComHandColor"))
                    Text("Free to post jobs")
                        .font(.caption)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color("primaryComHandColor"))
                    Text("Pay only when work is done")
                        .font(.caption)
                }
            }
            
            demoBadge(text: "Pre-filled for demo")
        }
    }
    
    // MARK: - Step 4: Homeowner Identity
    private var homeownerIdentityStepView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(TourStep.homeownerIdentity.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(TourStep.homeownerIdentity.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                TourFormField(label: "Full Name", value: demoHomeowner.fullName)
                TourFormField(label: "ID Type", value: demoHomeowner.idType)
                TourFormField(label: "ID Number", value: String(demoHomeowner.idNumber.prefix(6)) + "****")
            }
            .padding(.top, 20)
            
            // Security note
            HStack(spacing: 8) {
                Image(systemName: "lock.shield")
                    .foregroundColor(.green)
                Text("256-bit encrypted")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            demoBadge(text: "Pre-filled for demo")
        }
    }
    
    // MARK: - Step 5: Homeowner Terms (Background Check)
    private var homeownerTermsStepView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(TourStep.homeownerTerms.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(TourStep.homeownerTerms.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Background check highlight
            VStack(spacing: 16) {
                Image(systemName: "shield.checkered")
                    .font(.system(size: 50))
                    .foregroundColor(Color("primaryComHandColor"))
                
                Text("Background Check Required")
                    .font(.headline)
                
                Text("All homeowners must pass a background check before posting jobs. This is how we protect our teen helpers.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    
                    Text(demoHomeowner.backgroundCheckStatus)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .padding(.top, 20)
        }
    }
    
    // MARK: - Step 6: Create Job
    private var createJobStepView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(TourStep.createJob.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(TourStep.createJob.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Job creation form
            VStack(spacing: 16) {
                TourFormField(label: "Job Title", value: demoHomeowner.jobTitle)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Description")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(demoHomeowner.jobDescription)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                }
                
                HStack {
                    TourFormField(label: "Category", value: demoHomeowner.jobCategory)
                    Spacer()
                    TourFormField(label: "Budget", value: priceFormatter.string(from: NSNumber(value: demoHomeowner.jobBudget)) ?? "\(demoHomeowner.jobBudget)")
                }
            }
            .padding(.top, 20)
            
            demoBadge(text: "Pre-filled for demo")
        }
    }
    
    // MARK: - Step 7: Job Posted
    private var jobPostedStepView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(TourStep.jobPosted.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(TourStep.jobPosted.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Job card preview
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(demoHomeowner.jobTitle)
                            .font(.headline)
                        Text(demoHomeowner.jobCategory)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(priceFormatter.string(from: NSNumber(value: demoHomeowner.jobBudget)) ?? "\(demoHomeowner.jobBudget)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("primaryComHandColor"))
                }
                
                Divider()
                
                Text(demoHomeowner.jobDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "mappin")
                        .font(.caption)
                    Text(demoHomeowner.address)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("Just posted")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .padding(.top, 20)
            
            // Status indicator
            HStack(spacing: 8) {
                Image(systemName: "eye")
                    .foregroundColor(Color("primaryComHandColor"))
                Text("Visible to teens in your area")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Step 8: Teen Accepts
    private var teenAcceptsStepView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(TourStep.teenAccepts.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(TourStep.teenAccepts.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Teen profile card
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    // Avatar - real image
                    Image("marcus-williams")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .accessibilityHidden(true) // Name is shown next to image, no need for VoiceOver to announce filename
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(demoTeen.name)
                            .font(.headline)
                        
                        Text("Age \(demoTeen.age) • \(demoTeen.school)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundColor(.yellow)
                            Text(demoTeen.rating.formatted(.number.precision(.fractionLength(1))))
                                .font(.caption)
                            Text("• \(demoTeen.jobsCompleted) jobs")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                
                Divider()
                
                // Skills as simple text
                Text("Skills: \(demoTeen.skills.joined(separator: ", "))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                // Acceptance
                HStack(spacing: 8) {
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(.green)
                    Text("\(demoTeen.name) wants to help!")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                }
                .padding(.top, 8)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .padding(.top, 20)
        }
    }
    
    // MARK: - Step 9: Match Made
    private var matchMadeStepView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(TourStep.matchMade.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(TourStep.matchMade.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Connection visualization
            VStack(spacing: 20) {
                // Homeowner
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "house.fill")
                            .font(.title3)
                            .foregroundColor(.orange)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(demoHomeowner.fullName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("Homeowner")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                // Connection line
                HStack {
                    Spacer()
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color("primaryComHandColor"))
                            .frame(width: 2, height: 30)
                        
                        ZStack {
                            Circle()
                                .fill(Color("primaryComHandColor"))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "checkmark")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        
                        Rectangle()
                            .fill(Color("primaryComHandColor"))
                            .frame(width: 2, height: 30)
                    }
                    Spacer()
                }
                
                // Teen
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "person.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(demoTeen.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("Helper")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .padding(.top, 20)
            
            // Next steps
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "1.circle.fill")
                        .foregroundColor(Color("primaryComHandColor"))
                    Text("Message to confirm details")
                        .font(.caption)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "2.circle.fill")
                        .foregroundColor(Color("primaryComHandColor"))
                    Text("Schedule the work")
                        .font(.caption)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "3.circle.fill")
                        .foregroundColor(Color("primaryComHandColor"))
                    Text("Pay securely when complete")
                        .font(.caption)
                }
            }
            .padding(.top, 10)
        }
    }
    
    // MARK: - Step 10: Complete
    private var completeStepView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Success icon
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(Color("primaryComHandColor"))
            
            VStack(spacing: 12) {
                Text(TourStep.complete.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(TourStep.complete.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Navigation Buttons
    private var navigationButtons: some View {
        VStack(spacing: 12) {
            if currentStep == .complete {
                // Final step: Start real sign up
                Button(action: startRealSignUp) {
                    Text("Join our Community")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color("primaryComHandColor"))
                        )
                }
                
                Button(action: restartTour) {
                    Text("Back to Welcome")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                // Normal step: Next button
                Button(action: nextStep) {
                    HStack {
                        Text("Next")
                        Image(systemName: "chevron.right")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color("primaryComHandColor"))
                    )
                }
                
                // Auto-advance indicator
                Text("Auto-advancing in 8 seconds...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Helper Views
    private func demoBadge(text: String) -> some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(Color("primaryComHandColor"))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color("primaryComHandColor").opacity(0.1))
            )
    }
    
    // MARK: - Actions
    private func scheduleAutoAdvance() {
        // Cancel any existing task first
        autoAdvanceTask?.cancel()
        
        // Don't schedule if we're on the last step
        guard currentStep != .complete else { return }
        
        // Create new task for auto-advance
        autoAdvanceTask = Task {
            try? await Task.sleep(nanoseconds: 8_000_000_000) // 8 seconds
            guard !Task.isCancelled else { return }
            withAnimation { nextStep() }
        }
    }
    
    private func nextStep() {
        guard let next = TourStep(rawValue: currentStep.rawValue + 1) else {
            return
        }
        currentStep = next
    }
    
    private func skipTour() {
        // Cancel auto-advance before dismissing
        autoAdvanceTask?.cancel()
        dismiss()
    }
    
    private func restartTour() {
        withAnimation {
            currentStep = .welcome
        }
    }
    
    private func startRealSignUp() {
        withAnimation {
            showSignUp = true
        }
    }
}

// MARK: - Tour Progress Bar
// Visual indicator showing current progress through tour
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
                let progress = CGFloat(currentStep + 1) / CGFloat(totalSteps)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("primaryComHandColor"))
                    .frame(width: geometry.size.width * progress, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
            }
        }
        .frame(height: 8)
    }
}

// MARK: - Tour Form Field
// Pre-filled form field for demo mode
struct TourFormField: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
        }
    }
}

// MARK: - Demo Data Models
// Homeowner-focused sample data for pitch presentations
struct DemoHomeowner {
    let email: String
    let phone: String
    let fullName: String
    let idType: String
    let idNumber: String
    let address: String
    let householdSize: String
    let avatarInitials: String
    let bio: String
    let backgroundCheckStatus: String
    let jobTitle: String
    let jobDescription: String
    let jobBudget: Double
    let jobCategory: String
}

struct DemoTeen {
    let name: String
    let age: Int
    let school: String
    let skills: [String]
    let rating: Double
    let jobsCompleted: Int
    let initials: String
}

// MARK: - Preview
#Preview {
    InteractiveTourView()
        .environmentObject(AuthViewModel())
}
