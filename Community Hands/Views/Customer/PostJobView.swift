//
//  PostJobView.swift
//  Community Hands
//
//  Created by JOURNi Student on 8/1/26.
//

import SwiftUI
import SwiftData

// MARK: - Post Job View
// Allows homeowners to create new job listings
// Revenue-generating feature - core of the homeowner experience
struct PostJobView: View {
    // MARK: - Environment
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Form State
    @State private var title: String = ""
    @State private var category: String = "Lawn Care"
    @State private var jobDescription: String = ""
    @State private var priceString: String = ""
    @State private var location: String = ""
    
    // MARK: - UI State
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isSuccess: Bool = false
    
    // MARK: - Categories
    // Available job categories
    private let categories = [
        "Lawn Care",
        "Pet Care",
        "Babysitting",
        "Car Wash",
        "Tutoring",
        "House Cleaning",
        "Errands",
        "Other"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Job Basics
                Section(header: Text("Job Details")) {
                    TextField("Job Title", text: $title)
                        .autocapitalization(.words)
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                }
                
                // MARK: - Description
                Section(header: Text("Description")) {
                    TextEditor(text: $jobDescription)
                        .frame(minHeight: 100)
                        .overlay(
                            Group {
                                if jobDescription.isEmpty {
                                    Text("Describe what you need help with...")
                                        .foregroundColor(.gray)
                                        .padding(.top, 8)
                                        .padding(.leading, 5)
                                }
                            },
                            alignment: .topLeading
                        )
                }
                
                // MARK: - Budget
                Section(header: Text("Budget")) {
                    HStack {
                        Text("$")
                        TextField("0.00", text: $priceString)
                            .keyboardType(.decimalPad)
                    }
                }
                
                // MARK: - Location
                Section(header: Text("Location (Optional)")) {
                    TextField("Address or area", text: $location)
                }
                
                // MARK: - Post Button
                Section {
                    Button(action: postJob) {
                        HStack {
                            Spacer()
                            Text("Post Job")
                                .font(.headline)
                            Spacer()
                        }
                    }
                    .disabled(!isFormValid)
                    .foregroundColor(isFormValid ? Color("primaryComHandColor") : .gray)
                }
            }
            .navigationTitle("Post a Job")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .alert("Success!", isPresented: $isSuccess) {
                Button("Done", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("Your job has been posted and is now visible to teen helpers in your area.")
            }
        }
    }
    
    // MARK: - Validation
    // Check if form has minimum required fields
    // - Trim whitespace from strings
    // - Price must be positive (> 0)
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !jobDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !priceString.isEmpty &&
        (priceDecimal.map { $0 > 0 } ?? false)
    }
    
    // Convert price string to Decimal
    private var priceDecimal: Decimal? {
        Decimal(string: priceString)
    }
    
    // MARK: - Post Job Action
    // Creates and saves the job posting
    private func postJob() {
        guard let price = priceDecimal else {
            errorMessage = "Please enter a valid price"
            showError = true
            return
        }
        
        // Create new job posting
        // NOTE: In production, homeownerId would come from current user
        let job = JobPosting(
            title: title,
            category: category,
            jobDescription: jobDescription,
            price: price,
            location: location.isEmpty ? nil : location,
            homeownerId: UUID() // TODO: Use actual current user ID
        )
        
        // Save to SwiftData
        modelContext.insert(job)
        
        do {
            try modelContext.save()
            isSuccess = true
        } catch {
            errorMessage = "Failed to post job: \(error.localizedDescription)"
            showError = true
        }
    }
}

// MARK: - Preview
#Preview {
    PostJobView()
        .modelContainer(for: JobPosting.self, inMemory: true)
}
