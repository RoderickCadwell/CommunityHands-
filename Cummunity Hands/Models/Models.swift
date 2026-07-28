//
//  Models.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var fullName: String
    var email: String
    var isAdult: Bool
    
    init(fullName: String, email: String, isAdult: Bool) {
        self.id = UUID()
        self.fullName = fullName
        self.email = email
        self.isAdult = isAdult
    }
}

enum JobType: String, Codable, CaseIterable {
    case lawnMowing = "Lawn Mowing"
    case snowShoveling = "Snow Shoveling"
    case diyWork = "DIY Work"
    case eventPlanning = "Event Planning"
    case communityCleanup = "Community Cleanup"
}

enum PaymentType: String, Codable {
    case fixedWithPendingFee = "Fixed (Pending Completion)"
    case payOnSite = "Pay On-Site"
    case hourly = "Hourly Rate"
}

@Model
final class JobItem {
    var id: UUID
    var title: String
    var jobTypeRaw: String
    var estimatedDurationHours: Double
    var distanceMiles: Double
    var isHourly: Bool
    var hourlyRate: Double
    var baseFee: Double
    var paymentTypeRaw: String
    var isCompleted: Bool
    var dateCreated: Date

    init(title: String, jobType: JobType, estimatedDurationHours: Double, distanceMiles: Double, isHourly: Bool, hourlyRate: Double = 20.0, paymentType: PaymentType) {
        self.id = UUID()
        self.title = title
        self.jobTypeRaw = jobType.rawValue
        self.estimatedDurationHours = estimatedDurationHours
        self.distanceMiles = distanceMiles
        self.isHourly = isHourly
        self.hourlyRate = hourlyRate
        self.baseFee = 10.0
        self.paymentTypeRaw = paymentType.rawValue
        self.isCompleted = false
        self.dateCreated = Date()
    }

    var calculatedEstimate: Double {
        let distanceCost = distanceMiles * 1.50
        if isHourly {
            return distanceCost + (hourlyRate * estimatedDurationHours)
        } else {
            return distanceCost + baseFee + (estimatedDurationHours * 12.0)
        }
    }
}
