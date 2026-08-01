//
//  JobListingsView.swift
//  Community Hands
//
//  Created by JOURNi Student on 7/29/26.
//

import SwiftUI

// MARK: - Job Listing (Sample Data)
// Mock data struct for displaying job listings
// Renamed to avoid conflict with SwiftData JobPosting model
struct JobListing: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let price: Double
    let helperName: String
    let rating: Double
    let description: String
}

struct JobListingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var selectedJob: JobListing? = nil

    let categories = ["All", "Lawn Care", "Pet Care", "Babysitting", "Car Wash", "Tutoring"]

    let jobListings: [JobListing] = [
        JobListing(title: "Lawn Mowing & Edging", category: "Lawn Care", price: 35.00, helperName: "Alex R.", rating: 4.9, description: "Front and back lawn mowing, including line trimming around edges and driveway cleanup."),
        JobListing(title: "Dog Walking (30 Mins)", category: "Pet Care", price: 20.00, helperName: "Sarah M.", rating: 5.0, description: "30-minute neighborhood dog walk with updates and photos provided."),
        JobListing(title: "Basic Car Wash & Vacuum", category: "Car Wash", price: 25.00, helperName: "Jordan T.", rating: 4.8, description: "Exterior hand wash, wheel cleaning, and interior vacuuming."),
        JobListing(title: "Algebra 1 Tutoring", category: "Tutoring", price: 30.00, helperName: "Maya P.", rating: 4.9, description: "One-hour interactive math tutoring session for middle or high school students.")
    ]

    var filteredListings: [JobListing] {
        jobListings.filter { job in
            (selectedCategory == "All" || job.category == selectedCategory) &&
            (searchText.isEmpty || job.title.localizedCaseInsensitiveContains(searchText) || job.description.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search available services...", text: $searchText)
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    Text(category)
                                        .font(.subheadline)
                                        .fontWeight(selectedCategory == category ? .bold : .regular)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedCategory == category ? Color.green : Color(.systemGray5))
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

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredListings) { job in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(job.title)
                                            .font(.headline)
                                        
                                        HStack(spacing: 6) {
                                            Text(job.helperName)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            
                                            Text("•")
                                                .foregroundColor(.secondary)
                                            
                                            Image(systemName: "star.fill")
                                                .font(.caption)
                                                .foregroundColor(.yellow)
                                            
                                            Text(String(format: "%.1f", job.rating))
                                                .font(.subheadline)
                                                .bold()
                                        }
                                    }
                                    Spacer()
                                    
                                    Text("$\(String(format: "%.2f", job.price))")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(.green)
                                }

                                Text(job.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)

                                Button(action: {
                                    selectedJob = job
                                }) {
                                    HStack {
                                        Image(systemName: "cart.fill")
                                        Text("Purchase Service")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.green)
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
            .navigationTitle("Marketplace")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.green)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Log Out") {
                        authViewModel.logOut()
                    }
                    .foregroundColor(.red)
                }
            }
            .sheet(item: $selectedJob) { job in
                PurchaseConfirmationSheet(job: job)
            }
        }
    }
}

struct PurchaseConfirmationSheet: View {
    let job: JobListing
    @Environment(\.dismiss) var dismiss
    @State private var isPurchased = false

    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 10)

            if isPurchased {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)

                    Text("Purchase Confirmed!")
                        .font(.title2)
                        .bold()

                    Text("You have successfully purchased \(job.title) with \(job.helperName). They will contact you shortly to coordinate details.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Button("Done") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.vertical, 30)
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Confirm Order")
                        .font(.title2)
                        .bold()

                    Divider()

                    HStack {
                        Text("Service:")
                            .bold()
                        Spacer()
                        Text(job.title)
                    }

                    HStack {
                        Text("Helper:")
                            .bold()
                        Spacer()
                        Text(job.helperName)
                    }

                    HStack {
                        Text("Price:")
                            .bold()
                        Spacer()
                        Text("$\(String(format: "%.2f", job.price))")
                            .bold()
                            .foregroundColor(.green)
                    }

                    Divider()

                    Text("Payment Method")
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(.green)
                        Text("Apple Pay / Card ending in 4242")
                            .font(.subheadline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                    Spacer()

                    Button(action: {
                        withAnimation {
                            isPurchased = true
                        }
                    }) {
                        Text("Pay $\(String(format: "%.2f", job.price)) & Book Now")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    JobListingsView()
        .environmentObject(AuthViewModel())
}
