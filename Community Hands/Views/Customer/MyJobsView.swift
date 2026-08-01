//
//  MyJobsView.swift
//  Community Hands
//
//  Created by JOURNi Student on 8/1/26.
//

import SwiftUI
import SwiftData

// MARK: - My Jobs View
// Shows homeowner's posted jobs - active and completed
// Allows tracking job status and viewing helper assignments
struct MyJobsView: View {
    // MARK: - Environment
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Query
    // Fetch jobs posted by current homeowner
    // In production, filter by actual current user ID
    @Query(sort: \JobPosting.createdAt, order: .reverse) private var allJobs: [JobPosting]
    
    // MARK: - State
    @State private var selectedTab: JobTab = .active
    
    // MARK: - Tabs
    enum JobTab {
        case active
        case completed
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Tab Selector
                Picker("Job Status", selection: $selectedTab) {
                    Text("Active").tag(JobTab.active)
                    Text("Completed").tag(JobTab.completed)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // MARK: - Job List
                List {
                    ForEach(filteredJobs) { job in
                        JobRowView(job: job)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("My Jobs")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: PostJobView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    // MARK: - Filtered Jobs
    // Show jobs based on selected tab (Active vs Completed)
    // NOTE: In production, also filter by current homeowner ID
    private var filteredJobs: [JobPosting] {
        allJobs.filter { $0.isActive == (selectedTab == .active) }
    }
}

// MARK: - Job Row View
// Displays a single job in the list
struct JobRowView: View {
    let job: JobPosting
    
    var body: some View {
        NavigationLink(destination: JobDetailView(job: job)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(job.title)
                        .font(.headline)
                    
                    Spacer()
                    
                    // Price
                    Text(formatCurrency(job.price))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("primaryComHandColor"))
                }
                
                HStack {
                    // Category badge
                    Text(job.category)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    // Status indicator
                    JobStatusBadge(isActive: job.isActive)
                    
                    Spacer()
                    
                    // Date posted
                    Text(formatDate(job.createdAt))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Location if available
                if let location = job.location {
                    HStack {
                        Image(systemName: "mappin")
                            .font(.caption)
                        Text(location)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    // MARK: - Currency Formatter
    private func formatCurrency(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSDecimalNumber(decimal: value)) ?? "\(value)"
    }
    
    // MARK: - Date Formatter
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Job Status Badge
// Shows job status indicator (Active/Inactive)
struct JobStatusBadge: View {
    let isActive: Bool
    
    var body: some View {
        Text(isActive ? "Active" : "Inactive")
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(isActive ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
            .foregroundColor(isActive ? .green : .gray)
            .cornerRadius(8)
    }
}

// MARK: - Preview
#Preview {
    MyJobsView()
        .modelContainer(for: JobPosting.self, inMemory: true)
}
