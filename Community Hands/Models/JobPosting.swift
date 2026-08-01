//
//  JobPosting.swift
//  Community Hands
//
//  Created by JOURNi Student on 8/1/26.
//

import SwiftData
import Foundation

// MARK: - Job Posting Model
// SwiftData model for homeowner job listings
// Pure model - no view code here (views are in Views/Customer/)
//
// ARCHITECTURE NOTE: AcceptedJob is the SOURCE OF TRUTH for acceptance state.
// This model stores only the job definition. Acceptance status is DERIVED from
// AcceptedJob records. Query AcceptedJob to check if a job is accepted/completed.
@Model
class JobPosting {
    // MARK: - Identification
    var id: UUID
    
    // MARK: - Job Details
    var title: String
    var category: String // "Lawn Care", "Pet Care", "Babysitting", etc.
    var jobDescription: String
    // Use Decimal for currency to avoid floating-point rounding errors
    var price: Decimal // Budget for the job
    
    // MARK: - Location
    // Where the job is located
    var location: String?
    var latitude: Double?
    var longitude: Double?
    
    // MARK: - Status
    // Job posting state
    // isActive controls visibility in marketplace
    var isActive: Bool
    
    // NOTE: isAccepted/isCompleted are DERIVED from AcceptedJob records.
    // Use AcceptedJob.status to determine acceptance state, not this flag.
    
    // MARK: - Relationships
    // Who posted this job (homeowner)
    var homeownerId: UUID
    
    // MARK: - Metadata
    var createdAt: Date
    var updatedAt: Date
    
    // MARK: - Initialization
    init(
        id: UUID = UUID(),
        title: String,
        category: String,
        jobDescription: String,
        price: Decimal,
        location: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        isActive: Bool = true,
        homeownerId: UUID
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.jobDescription = jobDescription
        self.price = price
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.isActive = isActive
        self.homeownerId = homeownerId
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Job Categories
// Helper enum for type-safe category checking
extension JobPosting {
    enum Category: String, CaseIterable {
        case lawnCare = "Lawn Care"
        case petCare = "Pet Care"
        case babysitting = "Babysitting"
        case carWash = "Car Wash"
        case tutoring = "Tutoring"
        case houseCleaning = "House Cleaning"
        case errands = "Errands"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .lawnCare: return "leaf"
            case .petCare: return "pawprint"
            case .babysitting: return "person.2"
            case .carWash: return "car"
            case .tutoring: return "book"
            case .houseCleaning: return "sparkles"
            case .errands: return "bag"
            case .other: return "questionmark"
            }
        }
    }
}
