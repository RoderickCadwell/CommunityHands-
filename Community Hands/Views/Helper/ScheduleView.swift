//
//  ScheduleView.swift
//  Community Hands
//
//  Created by JOURNi Student on 8/1/26.
//

import SwiftUI
import SwiftData

// MARK: - Schedule View
// Shows teen's accepted jobs in a calendar-style view
// Displays upcoming and past jobs
struct ScheduleView: View {
    // MARK: - Environment
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Query
    // Fetch accepted jobs for current teen
    // In production, filter by actual current user ID
    @Query(sort: \AcceptedJob.acceptedAt, order: .reverse) private var myJobs: [AcceptedJob]
    
    // MARK: - State
    @State private var selectedTab: ScheduleTab = .upcoming
    
    // MARK: - Tabs
    enum ScheduleTab {
        case upcoming
        case past
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Tab Selector
                Picker("Schedule", selection: $selectedTab) {
                    Text("Upcoming").tag(ScheduleTab.upcoming)
                    Text("Past").tag(ScheduleTab.past)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // MARK: - Job List
                List {
                    ForEach(filteredJobs) { job in
                        ScheduleJobRow(job: job)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("My Schedule")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Filtered Jobs
    // Show jobs based on selected tab
    private var filteredJobs: [AcceptedJob] {
        switch selectedTab {
        case .upcoming:
            return myJobs.filter { $0.status != "Completed" && $0.status != "Cancelled" }
        case .past:
            return myJobs.filter { $0.status == "Completed" || $0.status == "Cancelled" }
        }
    }
}

// MARK: - Schedule Job Row
struct ScheduleJobRow: View {
    let job: AcceptedJob
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // Job status indicator
                StatusCircle(status: job.status)
                
                VStack(alignment: .leading) {
                    // TODO: Fetch actual job title from JobPosting
                    Text("Job #\(job.id.uuidString.prefix(8))")
                        .font(.headline)
                    
                    Text(formatDate(job.acceptedAt))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Price
                if let price = job.finalPrice {
                    Text(formatCurrency(price))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("primaryComHandColor"))
                }
            }
            
            // Status badge
            ScheduleStatusBadge(text: job.status, color: statusColor)
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Status Color
    private var statusColor: Color {
        switch job.status {
        case "Pending":
            return .orange
        case "In Progress":
            return .blue
        case "Completed":
            return .green
        case "Cancelled":
            return .red
        default:
            return .gray
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
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Status Circle
struct StatusCircle: View {
    let status: String
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 12, height: 12)
    }
    
    private var color: Color {
        switch status {
        case "Pending":
            return .orange
        case "In Progress":
            return .blue
        case "Completed":
            return .green
        case "Cancelled":
            return .red
        default:
            return .gray
        }
    }
}

// MARK: - Schedule Status Badge
struct ScheduleStatusBadge: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}

// MARK: - Preview
#Preview {
    ScheduleView()
        .modelContainer(for: AcceptedJob.self, inMemory: true)
}
