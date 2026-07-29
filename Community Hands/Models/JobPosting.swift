//
//  JobPosting.swift
//  Community Hands
//
//  Created by JOURNi Student on 7/29/26.
//


import SwiftUI

// MARK: - Models
struct AvailableJob: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let payout: Double
    let clientName: String
    let location: String
    let clientRating: Double
    let description: String
}

// MARK: - Loading View
// Dedicated loading screen for the Worker side, using blue theme.
struct WorkerLoadingView: View {
    let title: String
    let subtitle: String
    @Binding var isLoading: Bool
    var onComplete: () -> Void

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    // Outer spinning ring
                    Circle()
                        .stroke(Color.blue.opacity(0.1), lineWidth: 8)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: 0.6)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 80, height: 80)
                        .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isLoading)

                    // Inner worker icon (doesn't spin)
                    Image(systemName: "person.fill.checkmark")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }

                Text(title)
                    .font(.title3)
                    .bold()
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()
            }
        }
        .onAppear {
            // Simulate processing time before completion
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onComplete()
            }
        }
    }
}

// MARK: - Main Job Listings View
struct WorkerJobListingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    // Core State
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var selectedJob: AvailableJob? = nil

    // UI & Loading State
    @State private var showLoadingScreen = false
    @State private var jobToAccept: AvailableJob? = nil

    // Data Categories
    let categories = ["All", "Lawn Care", "Pet Care", "Babysitting", "Car Wash", "Tutoring"]

    // Sample Available Jobs Feed
    let availableJobs: [AvailableJob] = [
        AvailableJob(title: "Front Lawn Mowing & Edging", category: "Lawn Care", payout: 35.00, clientName: "John D.", location: "Oak Ridge • 1.2 miles", clientRating: 4.9, description: "Need front yard mowed this Saturday morning. Mower provided."),
        AvailableJob(title: "Dog Walking (30 Mins)", category: "Pet Care", payout: 20.00, clientName: "Emily S.", location: "Maple Street • 0.5 miles", clientRating: 5.0, description: "Looking for friendly dog walk around 2 PM."),
        AvailableJob(title: "Car Wash & Vacuum", category: "Car Wash", payout: 25.00, clientName: "Marcus T.", location: "Pine Drive • 2.1 miles", clientRating: 4.8, description: "Exterior wash & interior vacuum for sedan. Supplies provided."),
        AvailableJob(title: "Algebra 1 Tutoring", category: "Tutoring", payout: 30.00, clientName: "Lisa M.", location: "Public Library • 1.0 miles", clientRating: 4.9, description: "Looking for an hour of algebra homework help.")
    ]

    // Search & Filter Logic
    var filteredJobs: [AvailableJob] {
        availableJobs.filter { job in
            (selectedCategory == "All" || job.category == selectedCategory) &&
            (searchText.isEmpty || job.title.localizedCaseInsensitiveContains(searchText) || job.description.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    // MARK: - Search & Filter Header
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search jobs nearby...", text: $searchText)
                        }
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(categories, id: \.self) { category in
                                    Button(action: {
                                        withAnimation {
                                            selectedCategory = category
                                        }
                                    }) {
                                        Text(category)
                                            .font(.subheadline)
                                            .fontWeight(selectedCategory == category ? .bold : .regular)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(selectedCategory == category ? Color.blue : Color(.systemGray5))
                                            .foregroundColor(selectedCategory == category ? .white : .primary)
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 10)
                    .background(Color(.systemBackground))

                    Divider()

                    // MARK: - Available Jobs Feed
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredJobs) { job in
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(job.title)
                                                .font(.headline)
                                            
                                            HStack(spacing: 6) {
                                                Text(job.clientName)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                
                                                Text("•")
                                                    .foregroundColor(.secondary)
                                                
                                                Image(systemName: "star.fill")
                                                    .font(.caption)
                                                    .foregroundColor(.yellow)
                                                
                                                Text(String(format: "%.1f", job.clientRating))
                                                    .font(.subheadline)
                                                    .bold()
                                            }
                                            
                                            HStack(spacing: 4) {
                                                Image(systemName: "mappin.and.ellipse")
                                                    .font(.caption)
                                                    .foregroundColor(.blue)
                                                Text(job.location)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding(.top, 2)
                                        }
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 2) {
                                            Text("$\(String(format: "%.2f", job.payout))")
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(.blue)
                                            Text("Payout")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                    }

                                    Text(job.description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)

                                    // MARK: - Action Button
                                    Button(action: {
                                        jobToAccept = job
                                        withAnimation {
                                            showLoadingScreen = true
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                            Text("Accept Job")
                                        }
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                    }
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Available Jobs")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") { dismiss() }
                            .foregroundColor(.blue)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Log Out") { authViewModel.logOut() }
                            .foregroundColor(.red)
                    }
                }

                // MARK: - Integrated Blue Loading Icon Overlay
                if showLoadingScreen {
                    WorkerLoadingView(
                        title: "Accepting Job",
                        subtitle: "Confirming details and notifying the client...",
                        isLoading: $showLoadingScreen
                    ) {
                        // When loading completes, transition seamlessly to the confirmation sheet
                        selectedJob = jobToAccept
                        withAnimation {
                            showLoadingScreen = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1) // Ensures loading screen covers the list
                }
            }
            // Displays confirmation modal after loading
            .sheet(item: $selectedJob) { job in
                JobAcceptanceConfirmationSheet(job: job)
            }
        }
    }
}

// MARK: - Job Acceptance Confirmation Modal
struct JobAcceptanceConfirmationSheet: View {
    let job: AvailableJob
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 10)

            VStack(spacing: 16) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)

                Text("Job Accepted!")
                    .font(.title2)
                    .bold()

                Text("You're scheduled for \(job.title) with \(job.clientName). Check your active schedule for updates.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Divider()
                    .padding(.vertical, 10)

                // Summary details
                VStack(spacing: 12) {
                    summaryRow(title: "Earnings", value: "$\(String(format: "%.2f", job.payout))", valueColor: .blue)
                    summaryRow(title: "Location", value: job.location)
                }
                .padding(.horizontal)

                Spacer()

                Button("Done") {
                    dismiss()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.vertical, 10)
        }
    }

    private func summaryRow(title: String, value: String, valueColor: Color = .primary) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .bold()
                .foregroundColor(valueColor)
        }
    }
}

// MARK: - Preview
#Preview {
    WorkerJobListingsView()
        .environmentObject(AuthViewModel())
}
