//
//  JobListingsView.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/29/26.
//

import SwiftUI

struct JobListingsView: View {
    @Environment(\.dismiss) var dismiss

    @State private var selectedFilter: String = "All"
    @State private var searchText: String = ""

    let filterOptions = ["All", "Yard Work", "Erlands", "Pet Care", "Housework"]

    // Mock dataset centered around East Village & Highland Park
    @State private var mockJobs: [LocalJob] = [
        LocalJob(
            clientName: "John",
            clientImageName: "person.crop.circle.fill",
            taskDescription: "Needs help with yard work & lawn mowing.",
            payout: 22.89,
            distanceMiles: 1.0
        ),
        LocalJob(
            clientName: "Mrs. Davis",
            clientImageName: "person.crop.circle.fill",
            taskDescription: "Grocery pickup & delivery from local market.",
            payout: 18.50,
            distanceMiles: 0.6
        ),
        LocalJob(
            clientName: "Robert",
            clientImageName: "person.crop.circle.fill",
            taskDescription: "Dog walking (2 friendly Golden Retrievers).",
            payout: 25.00,
            distanceMiles: 1.4
        ),
        LocalJob(
            clientName: "Eleanor",
            clientImageName: "person.crop.circle.fill",
            taskDescription: "Help moving garden pots & rake leaves.",
            payout: 30.00,
            distanceMiles: 2.1
        )
    ]

    var filteredJobs: [LocalJob] {
        if searchText.isEmpty {
            return mockJobs
        } else {
            return mockJobs.filter {
                $0.taskDescription.localizedCaseInsensitiveContains(searchText) ||
                $0.clientName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Mock Background Pattern (Light grid tone)
                Color(red: 0.95, green: 0.95, blue: 0.93)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    // Top Header Bar
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Back to Map")
                            }
                            .font(.headline)
                            .bold()
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                        }

                        Spacer()

                        Text("Job Board")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)

                        Spacer()
                        
                        // Spacer balancing for back button layout
                        Color.clear
                            .frame(width: 80, height: 30)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    // Mock Search Input Field
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.headline)
                            .foregroundColor(.black)
                        TextField("Search local neighborhood tasks...", text: $searchText)
                            .font(.subheadline)
                            .autocapitalization(.none)
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                    .padding(.horizontal)

                    // Filter Pills (Mock Style)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(filterOptions, id: \.self) { filter in
                                Button(action: {
                                    selectedFilter = filter
                                }) {
                                    Text(filter)
                                        .font(.subheadline)
                                        .bold()
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedFilter == filter ? Color(red: 0.45, green: 0.75, blue: 0.35) : Color.white)
                                        .foregroundColor(selectedFilter == filter ? .white : .black)
                                        .cornerRadius(20)
                                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 2))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Mock Listings Feed
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredJobs, id: \.clientName) { job in
                                MockJobCard(job: job)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

// Custom Hand-Drawn Mock Card Component
struct MockJobCard: View {
    let job: LocalJob
    @State private var isAccepted = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header Row: Avatar, Name & Payout
            HStack(alignment: .top) {
                HStack(spacing: 12) {
                    Image(systemName: job.clientImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.black)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(job.clientName)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.black)

                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                            Text("\(String(format: "%.1f", job.distanceMiles)) Mile away")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.black.opacity(0.7))
                        }
                    }
                }

                Spacer()

                // Mock Payout Badge
                Text("$\(String(format: "%.2f", job.payout))")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.85, green: 0.95, blue: 0.80))
                    .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
            }

            // Description Box
            Text(job.taskDescription)
                .font(.body)
                .bold()
                .foregroundColor(.black.opacity(0.9))

            // Mock Action Row
            HStack(spacing: 12) {
                Button(action: {
                    withAnimation(.spring()) {
                        isAccepted.toggle()
                    }
                }) {
                    Text(isAccepted ? "Accepted ✓" : "Accept")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(isAccepted ? Color.gray : Color.green)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                }

                Button(action: {
                    // Open mock job details
                }) {
                    Text("Details")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black, lineWidth: 3))
        .shadow(color: Color.black.opacity(0.12), radius: 0, x: 4, y: 4) // Block shadow effect
    }
}

#Preview {
    JobListingsView()
        .environmentObject(AuthViewModel())
}
