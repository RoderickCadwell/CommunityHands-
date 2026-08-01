//
//  TermsAcceptance.swift
//  Community Hands
//
//  Created by JOURNi Student on 8/1/26.
//

import SwiftData
import Foundation

// MARK: - Terms Acceptance Model
// SwiftData model for recording user agreement to terms and waiver
// Required for both homeowners and teens
// NOTE: Parent signature validation for users under 18 is enforced in the acceptance flow code, not here
@Model
class TermsAcceptance {
    // MARK: - Identification
    var id: UUID
    
    // MARK: - User Reference
    // Which user accepted
    var userId: UUID
    
    // MARK: - Signature Details
    // Printed name (required)
    // NOTE: Store unencrypted. Consider encryption for production apps.
    var printedName: String
    
    // Electronic signature (typed or drawn)
    // NOTE: Store unencrypted. Consider encryption for production apps.
    var electronicSignature: String
    
    // Parent/guardian signature (required for teens under 18)
    // NOTE: Validation happens in Terms acceptance flow - checks User.age < 18
    // NOTE: Store unencrypted. Consider encryption for production apps.
    var parentSignature: String?
    
    // Parent name and relationship
    var parentName: String?
    var parentRelationship: String?
    
    // MARK: - Terms Version
    // Which version of terms were accepted (e.g., "1.0", "1.1")
    // NO DEFAULT - must be passed explicitly to ensure correct version recorded
    var termsVersion: String
    
    // Whether user explicitly accepted terms
    // NO DEFAULT - must be passed explicitly (true means user tapped "I Agree")
    var termsAccepted: Bool
    
    // MARK: - Acknowledgments
    // NO DEFAULTS - caller must pass explicit values
    var acknowledgedBackgroundCheck: Bool // For homeowners
    var acknowledgedSafetyTraining: Bool // For teens
    
    // MARK: - Metadata
    var acceptedAt: Date
    
    // NOTE: Removed ipAddress and deviceIdentifier - not needed for local-only storage
    // and reduces privacy/GDPR/CCPA/COPPA compliance burden for minors
    
    // MARK: - Initialization
    // All terms fields required - no defaults to prevent accidental acceptance recording
    init(
        id: UUID = UUID(),
        userId: UUID,
        printedName: String,
        electronicSignature: String,
        termsVersion: String,
        termsAccepted: Bool,
        acknowledgedBackgroundCheck: Bool,
        acknowledgedSafetyTraining: Bool,
        parentSignature: String? = nil,
        parentName: String? = nil,
        parentRelationship: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.printedName = printedName
        self.electronicSignature = electronicSignature
        self.termsVersion = termsVersion
        self.termsAccepted = termsAccepted
        self.acknowledgedBackgroundCheck = acknowledgedBackgroundCheck
        self.acknowledgedSafetyTraining = acknowledgedSafetyTraining
        self.parentSignature = parentSignature
        self.parentName = parentName
        self.parentRelationship = parentRelationship
        self.acceptedAt = Date()
    }
}
