//
//  EarningsView.swift
//  Community Hands
//
//  Created by JOURNi Student on 8/1/26.
//

import SwiftUI
import SwiftData

// MARK: - Earnings View
// Shows teen's total earnings and completed jobs
// Tracks payment status and earnings history
struct EarningsView: View {
    // MARK: - Environment
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Query
    // Fetch completed jobs for current teen
    @Query(filter: #Predicate<AcceptedJob> { $0.status == "Completed" }) private var completedJobs: [AcceptedJob]
    
    // MARK: - Computed Properties
    // Total earnings from all completed jobs
    private var totalEarnings: Decimal {
        completedJobs.compactMap { $0.finalPrice }.reduce(0, +)
    }
    
    // Total earnings paid
    private var earningsPaid: Decimal {
        completedJobs
            .filter { $0.paymentStatus == "Paid" }
            .compactMap { $0.finalPrice }
            .reduce(0, +)
    }
    
    // Total earnings pending
    private var earningsPending: Decimal {
        completedJobs
            .filter { $0.paymentStatus == "Pending" }
            .compactMap { $0.finalPrice }
            .reduce(0, +)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Total Earnings Card
                    EarningsCard(
                        title: "Total Earnings",
                        amount: totalEarnings,
                        color: Color("primaryComHandColor")
                    )
                    
                    // MARK: - Payment Status
                    HStack(spacing: 16) {
                        EarningsStatusCard(
                            title: "Paid",
                            amount: earningsPaid,
                            color: .green
                        )
                        
                        EarningsStatusCard(
                            title: "Pending",
                            amount: earningsPending,
                            color: .orange
                        )
                    }
                    
                    // MARK: - Completed Jobs List
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Completed Jobs")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(completedJobs) { job in
                            EarningsJobRow(job: job)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("My Earnings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Earnings Card
struct EarningsCard: View {
    let title: String
    let amount: Decimal
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(formatCurrency(amount))
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
    
    private func formatCurrency(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSDecimalNumber(decimal: value)) ?? "\(value)"
    }
}

// MARK: - Earnings Status Card
struct EarningsStatusCard: View {
    let title: String
    let amount: Decimal
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(formatCurrency(amount))
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private func formatCurrency(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSDecimalNumber(decimal: value)) ?? "\(value)"
    }
}

// MARK: - Earnings Job Row
struct EarningsJobRow: View {
    let job: AcceptedJob
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                // TODO: Fetch actual job title from JobPosting
                Text("Job #\(job.id.uuidString.prefix(8))")
                    .font(.headline)
                
                if let completedAt = job.completedAt {
                    Text("Completed \(formatDate(completedAt))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                if let price = job.finalPrice {
                    Text(formatCurrency(price))
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                
                // Payment status
                Text(job.paymentStatus)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        job.paymentStatus == "Paid" ? Color.green.opacity(0.2) : Color.orange.opacity(0.2)
                    )
                    .foregroundColor(job.paymentStatus == "Paid" ? .green : .orange)
                    .cornerRadius(4)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private func formatCurrency(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSDecimalNumber(decimal: value)) ?? "\(value)"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Preview
#Preview {
    EarningsView()
        .modelContainer(for: AcceptedJob.self, inMemory: true)
}
