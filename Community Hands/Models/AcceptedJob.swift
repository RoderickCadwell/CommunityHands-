//
//  AcceptedJob.swift
//  Community Hands
//
//  Created by JOURNi Student on 8/1/26.
//

import SwiftData
import Foundation

// MARK: - Accepted Job Model
// SwiftData model for job acceptances by teen helpers
// Tracks the relationship between a teen and a job they accepted
//
// ARCHITECTURE NOTE: This is the SOURCE OF TRUTH for acceptance state.
// JobPosting derives its accepted/completed flags from this record.
// Always update AcceptedJob first, then derive JobPosting state.
@Model
class AcceptedJob {
    // MARK: - Identification
    var id: UUID
    
    // MARK: - Relationships
    // Reference to the job posting (not a direct relationship in SwiftData beta)
    var jobPostingId: UUID
    
    // The teen who accepted
    var teenId: UUID
    
    // The homeowner who posted
    var homeownerId: UUID
    
    // MARK: - Status
    var status: String // "Pending", "In Progress", "Completed", "Cancelled"
    
    // MARK: - Timeline
    var acceptedAt: Date
    var startedAt: Date?
    var completedAt: Date?
    var cancelledAt: Date?
    
    // MARK: - Ratings (1-5 scale)
    // Rating given BY homeowner TO teen
    var ratingByHomeowner: Int?
    var reviewByHomeowner: String?
    var homeownerRatedAt: Date?
    
    // Rating given BY teen TO homeowner  
    var ratingByTeen: Int?
    var reviewByTeen: String?
    var teenRatedAt: Date?
    
    // MARK: - Payment
    var finalPrice: Decimal? // May differ from posted price
    var paymentStatus: String // "Pending", "Paid"
    var paidAt: Date?
    
    // MARK: - Initialization
    init(
        id: UUID = UUID(),
        jobPostingId: UUID,
        teenId: UUID,
        homeownerId: UUID,
        status: String = "Pending",
        acceptedAt: Date = Date(),
        startedAt: Date? = nil,
        completedAt: Date? = nil,
        cancelledAt: Date? = nil,
        finalPrice: Decimal? = nil,
        paymentStatus: String = "Pending",
        paidAt: Date? = nil
    ) {
        self.id = id
        self.jobPostingId = jobPostingId
        self.teenId = teenId
        self.homeownerId = homeownerId
        self.status = status
        self.acceptedAt = acceptedAt
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.cancelledAt = cancelledAt
        self.finalPrice = finalPrice
        self.paymentStatus = paymentStatus
        self.paidAt = paidAt
    }
}

// MARK: - Status Enum
extension AcceptedJob {
    enum Status: String {
        case pending = "Pending"
        case inProgress = "In Progress"
        case completed = "Completed"
        case cancelled = "Cancelled"
    }
    
    var statusEnum: Status? {
        Status(rawValue: status)
    }
    
    // MARK: - Rating Constants
    static let ratingRange = 1...5
    
    // MARK: - Rating Setters
    // Use these to ensure valid ratings and update timestamps
    func setRatingByHomeowner(_ value: Int, review: String? = nil) {
        guard Self.ratingRange.contains(value) else { return }
        ratingByHomeowner = value
        reviewByHomeowner = review
        homeownerRatedAt = Date()
    }
    
    func setRatingByTeen(_ value: Int, review: String? = nil) {
        guard Self.ratingRange.contains(value) else { return }
        ratingByTeen = value
        reviewByTeen = review
        teenRatedAt = Date()
    }
}
