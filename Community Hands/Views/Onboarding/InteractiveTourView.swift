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
// 8 steps showing full app flow from welcome to marketplace
struct InteractiveTourView: View {
    // MARK: - Environment
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Tour State
    @State private var currentStep: TourStep = .welcome
    @State private var showSignUp = false
    @State private var autoAdvanceTask: Task<Void, Never>?
    
    // MARK: - Demo Data
    // Pre-filled sample data for the tour
    private let demoUser = DemoUser(
        email: "demo@communityhands.app",
        phone: "555-DEMO-001",
        fullName: "Sarah Johnson",
        idType: "Driver's License",
        idNumber: "DEMO-ID-12345",
        role: "Community Member",
        bio: "Working parent looking for reliable help with yard work and pet care."
    )
    
    private let demoJobs = [
        DemoJob(title: "Lawn Mowing & Edging", category: "Lawn Care", price: 35.00),
        DemoJob(title: "Dog Walking (30 min)", category: "Pet Care", price: 20.00),
        DemoJob(title: "Weekend Babysitting", category: "Child Care", price: 15.00),
        DemoJob(title: "Car Wash & Vacuum", category: "Car Wash", price: 25.00)
    ]
    
    // Locale-aware currency formatter
    private var priceFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }
    
    // MARK: - Tour Steps
    enum TourStep: Int, CaseIterable {
        case welcome = 0
        case signUp
        case identity
        case terms
        case bio
        case mainMenu
        case marketplace
        case complete
        
        // Total number of steps for progress calculation
        static var count: Int { allCases.count }
        
        // Display title for each step
        var title: String {
            switch self {
            case .welcome:
                return "Welcome to Community Hands"
            case .signUp:
                return "Quick Account Setup"
            case .identity:
                return "Verify Your Identity"
            case .terms:
                return "Review Terms & Waiver"
            case .bio:
                return "Complete Your Profile"
            case .mainMenu:
                return "Find Local Help"
            case .marketplace:
                return "Browse Services"
            case .complete:
                return "Ready to Get Started?"
            }
        }
        
        // Description text explaining each step
        var description: String {
            switch self {
            case .welcome:
                return "A marketplace connecting teens with homeowners who need help with everyday tasks."
            case .signUp:
                return "Create an account with your email or phone number. In demo mode, we auto-fill this for you."
            case .identity:
                return "Verify your identity for safety. Homeowners require background checks to protect our teen helpers."
            case .terms:
                return "Review and accept the terms. Our platform connects you with local help while keeping everyone safe."
            case .bio:
                return "Tell us about yourself. Homeowners can see your bio when browsing for helpers."
            case .mainMenu:
                return "Homeowners post jobs and browse teen helpers in their neighborhood."
            case .marketplace:
                return "Browse available services: Lawn Care, Pet Care, Babysitting, Car Wash, and more."
            case .complete:
                return "You've seen how Community Hands works. Ready to create your real account?"
            }
        }
    }

    // MARK: - Body
    var body: some View {
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
            
            // MARK: - Navigation to SignUp
            // Rendered conditionally for smooth transition
            if showSignUp {
                SignUpView()
                    .transition(.opacity)
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
    @ViewBuilder
    private var currentStepContent: some View {
        switch currentStep {
        case .welcome:
            welcomeStepView
        case .signUp:
            signUpStepView
        case .identity:
            identityStepView
        case .terms:
            termsStepView
        case .bio:
            bioStepView
        case .mainMenu:
            mainMenuStepView
        case .marketplace:
            marketplaceStepView
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
            
            // Title and description
            VStack(spacing: 12) {
                Text(TourStep.welcome.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(TourStep.welcome.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Community connection visual
            HStack(spacing: 40) {
                VStack(spacing: 8) {
                    Image(systemName: "person.fill.checkmark")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    Text("Teens")
                        .font(.caption)
                        .fontWeight(.medium)
                    Text("Need Experience")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 32))
                    .foregroundColor(Color("primaryComHandColor"))
                
                VStack(spacing: 8) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    Text("Homeowners")
                        .font(.caption)
                        .fontWeight(.medium)
                    Text("Need Help")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 20)
        }
    }
    
    // MARK: - Step 2: Sign Up
    private var signUpStepView: some View {
        VStack(spacing: 24) {
            // Title
            VStack(spacing: 8) {
                Text(TourStep.signUp.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(TourStep.signUp.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Pre-filled form
            VStack(spacing: 16) {
                // Email field
                TourFormField(label: "Email or Phone", value: demoUser.email)
                
                // Phone field
                TourFormField(label: "Phone", value: demoUser.phone)
            }
            .padding(.top, 20)
            
            // Demo badge
            demoBadge(text: "Pre-filled for demo")
        }
    }
    
    // MARK: - Step 3: Identity
    private var identityStepView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(TourStep.identity.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(TourStep.identity.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                TourFormField(label: "Full Name", value: demoUser.fullName)
                TourFormField(label: "ID Type", value: demoUser.idType)
                TourFormField(label: "ID Number", value: demoUser.idNumber)
            }
            .padding(.top, 20)
            
            demoBadge(text: "Pre-filled for demo")
        }
    }
    
    // MARK: - Step 4: Terms
    private var termsStepView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(TourStep.terms.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(TourStep.terms.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Mock terms content
            VStack(alignment: .leading, spacing: 12) {
                Text("User Agreement Preview")
                    .font(.headline)
                
                Text("1. Community Hands connects homeowners with teen helpers...")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("2. All users must verify identity for safety...")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("3. Background checks required for homeowners...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.top, 20)
            
            // Pre-checked agreement
            HStack(spacing: 12) {
                Image(systemName: "checkmark.square.fill")
                    .foregroundColor(Color("primaryComHandColor"))
                
                Text("I agree to the terms (demo)")
                    .font(.subheadline)
            }
            .padding(.top, 10)
        }
    }
    
    // MARK: - Step 5: Bio
    private var bioStepView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(TourStep.bio.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(TourStep.bio.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                // Role selection
                TourFormField(label: "Role", value: demoUser.role)
                
                // Bio text
                VStack(alignment: .leading, spacing: 6) {
                    Text("Bio")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(demoUser.bio)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                }
            }
            .padding(.top, 20)
            
            demoBadge(text: "Pre-filled for demo")
        }
    }
    
    // MARK: - Step 6: Main Menu
    private var mainMenuStepView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(TourStep.mainMenu.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(TourStep.mainMenu.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Mock map area
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 200)
                
                // Mock pins
                HStack(spacing: 80) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text("Your Location")
                            .font(.caption)
                    }
                    
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                        Text("Helpers Nearby")
                            .font(.caption)
                    }
                }
            }
            .padding(.top, 20)
            
            // Sample job card
            VStack(alignment: .leading, spacing: 8) {
                Text("Sample Job Nearby")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Lawn Mowing")
                            .font(.headline)
                        Text("1.2 miles away")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("$35")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("primaryComHandColor"))
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Step 7: Marketplace
    private var marketplaceStepView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(TourStep.marketplace.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(TourStep.marketplace.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Sample job listings
            VStack(spacing: 12) {
                ForEach(demoJobs.prefix(3), id: \.title) { job in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(job.title)
                                .font(.headline)
                            Text(job.category)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(priceFormatter.string(from: NSNumber(value: job.price)) ?? "$\(job.price)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("primaryComHandColor"))
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
            }
            .padding(.top, 20)
            
            // Category pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["All", "Lawn Care", "Pet Care", "Babysitting"], id: \.self) { category in
                        Text(category)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(category == "All" ? Color("primaryComHandColor") : Color(.secondarySystemBackground))
                            )
                            .foregroundColor(category == "All" ? .white : .primary)
                    }
                }
            }
        }
    }
    
    // MARK: - Step 8: Complete
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
                    Text("Start Real Sign Up")
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
// Sample data for the tour
struct DemoUser {
    let email: String
    let phone: String
    let fullName: String
    let idType: String
    let idNumber: String
    let role: String
    let bio: String
}

struct DemoJob {
    let title: String
    let category: String
    let price: Double
}

// MARK: - Preview
#Preview {
    InteractiveTourView()
        .environmentObject(AuthViewModel())
}
