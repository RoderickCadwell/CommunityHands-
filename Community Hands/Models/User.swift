//
//  User.swift
//  Community Hands
//
//  Created by JOURNi Student on 8/1/26.
//

import SwiftData
import Foundation

// MARK: - User Model
// SwiftData model for app users (both homeowners and teens)
// Persists user profile data locally for MVP
//
// SECURITY NOTE: idNumberLast4 stores only last 4 digits of government ID.
// Full ID value should not be stored in SwiftData (unencrypted SQLite).
// Consider Keychain for full ID or hash-based verification in production.
@Model
class User {
    // MARK: - Identity
    // Unique identifier for the user
    var id: UUID
    
    // Contact information
    var emailOrPhone: String
    var phone: String?
    
    // Full name from ID verification
    var fullName: String
    
    // MARK: - Verification
    // ID verification details for safety
    var idType: String
    // SECURITY: Only store last 4 digits. Full ID should NOT be in SwiftData.
    var idNumberLast4: String
    var idVerifiedAt: Date?
    
    // MARK: - Role & Profile
    // User role determines flow (homeowner vs teen)
    var role: String // "Homeowner", "Teen Helper", "Community Member"
    
    // Bio for profile display
    var bio: String?
    
    // Avatar/profile image (stored as filename reference)
    var avatarImageName: String?
    
    // MARK: - Safety
    // Background check status (required for homeowners)
    var hasBackgroundCheck: Bool
    var backgroundCheckDate: Date?
    
    // Is this a teen account (determines helper flow)
    var isTeen: Bool
    var age: Int?
    
    // MARK: - Account Status
    var hasAcceptedTerms: Bool
    var termsAcceptedAt: Date?
    
    var isActive: Bool
    
    // MARK: - Metadata
    var createdAt: Date
    var updatedAt: Date
    
    // MARK: - Initialization
    init(
        id: UUID = UUID(),
        emailOrPhone: String,
        phone: String? = nil,
        fullName: String,
        idType: String = "",
        idNumberLast4: String = "",
        idVerifiedAt: Date? = nil,
        role: String,
        bio: String? = nil,
        avatarImageName: String? = nil,
        hasBackgroundCheck: Bool = false,
        backgroundCheckDate: Date? = nil,
        isTeen: Bool = false,
        age: Int? = nil,
        hasAcceptedTerms: Bool = false,
        termsAcceptedAt: Date? = nil,
        isActive: Bool = true
    ) {
        self.id = id
        self.emailOrPhone = emailOrPhone
        self.phone = phone
        self.fullName = fullName
        self.idType = idType
        self.idNumberLast4 = idNumberLast4
        self.idVerifiedAt = idVerifiedAt
        self.role = role
        self.bio = bio
        self.avatarImageName = avatarImageName
        self.hasBackgroundCheck = hasBackgroundCheck
        self.backgroundCheckDate = backgroundCheckDate
        self.isTeen = isTeen
        self.age = age
        self.hasAcceptedTerms = hasAcceptedTerms
        self.termsAcceptedAt = termsAcceptedAt
        self.isActive = isActive
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    // MARK: - Update Tracking
    /// Call after any mutation to keep `updatedAt` accurate.
    func touch() {
        updatedAt = Date()
    }
}

// MARK: - User Role Enum
// Helper enum for type-safe role checking
extension User {
    enum Role: String {
        case homeowner = "Homeowner"
        case teenHelper = "Teen Helper"
        case communityMember = "Community Member"
    }
    
    var roleEnum: Role? {
        Role(rawValue: role)
    }
}
