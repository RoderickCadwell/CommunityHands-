//
//  JobDetailView.swift
//  Community Hands
//
//  Created by JOURNi Student on 8/1/26.
//

import SwiftUI
import SwiftData

// MARK: - Job Detail View
// Shows full details of a job posting
// Allows edit/delete for job owner
struct JobDetailView: View {
    // MARK: - Environment
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Properties
    let job: JobPosting
    
    // MARK: - State
    @State private var showDeleteConfirmation: Bool = false
    @State private var showEditSheet: Bool = false
    @State private var isDeleted: Bool = false
    @State private var showDeleteError: Bool = false
    @State private var deleteErrorMessage: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // MARK: - Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(job.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        // Price
                        Text(formatCurrency(job.price))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("primaryComHandColor"))
                    }
                    
                    // Category
                    Text(job.category)
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    // Status
                    HStack {
                        Circle()
                            .fill(job.isActive ? Color.green : Color.gray)
                            .frame(width: 8, height: 8)
                        
                        Text(job.isActive ? "Active" : "Inactive")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("• Posted \(formatDate(job.createdAt))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                // MARK: - Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)
                    
                    Text(job.jobDescription)
                        .font(.body)
                }
                
                // MARK: - Location
                if let location = job.location {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Location")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "mappin")
                            Text(location)
                        }
                        .font(.body)
                        .foregroundColor(.secondary)
                    }
                }
                
                // MARK: - Actions
                HStack(spacing: 16) {
                    // Edit Button
                    Button(action: { showEditSheet = true }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Edit")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                    }
                    
                    // Delete Button
                    Button(action: { showDeleteConfirmation = true }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.2))
                        .foregroundColor(.red)
                        .cornerRadius(12)
                    }
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Job?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteJob()
            }
        } message: {
            Text("This will permanently remove this job posting.")
        }
        .alert("Error", isPresented: $showDeleteError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(deleteErrorMessage)
        }
        .sheet(isPresented: $showEditSheet) {
            // EditJobView would go here
            Text("Edit functionality coming in Phase 6")
                .font(.headline)
                .padding()
        }
    }
    
    // MARK: - Delete Job
    private func deleteJob() {
        modelContext.delete(job)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            deleteErrorMessage = "Failed to delete job: \(error.localizedDescription)"
            showDeleteError = true
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
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        JobDetailView(job: JobPosting(
            title: "Lawn Mowing",
            category: "Lawn Care",
            jobDescription: "Need front and back yard mowed",
            price: 45.00,
            location: "Oak Park, MI",
            homeownerId: UUID()
        ))
    }
    .modelContainer(for: JobPosting.self, inMemory: true)
}
