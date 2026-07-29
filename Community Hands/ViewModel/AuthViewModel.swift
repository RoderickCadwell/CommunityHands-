//
//  AuthViewModel.swift
//  Community Hands
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    // MARK: - Persistent App Storage Properties
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    // MARK: - Navigation & Auth State Properties
    @Published var isAuthenticated: Bool = false
    @Published var userEmailOrPhone: String = ""
    @Published var userFullName: String = ""
    @Published var userIDType: String = ""
    @Published var userIDNumber: String = ""
    @Published var hasUploadedID: Bool = false
    @Published var errorMessage: String? = nil

    init() {
        self.isAuthenticated = self.isLoggedIn
    }

    // Direct Login: Existing users skip onboarding and go straight to Marketplace
    func logIn(emailOrPhone: String) {
        self.userEmailOrPhone = emailOrPhone
        self.isLoggedIn = true
        self.isAuthenticated = true
        self.hasCompletedOnboarding = true
        self.errorMessage = nil
    }

    func login() {
        self.isLoggedIn = true
        self.isAuthenticated = true
        self.hasCompletedOnboarding = true
        self.errorMessage = nil
    }

    // Sign Up: New users are forced through Terms & Bio onboarding
    func signUp() {
        self.isLoggedIn = true
        self.isAuthenticated = true
        self.hasCompletedOnboarding = false
        self.errorMessage = nil
    }

    func finalizeSignUp(fullName: String, idType: String, idNumber: String) {
        self.userFullName = fullName
        self.userIDType = idType
        self.userIDNumber = idNumber
        self.isLoggedIn = true
        self.isAuthenticated = true
        self.hasCompletedOnboarding = false
        self.errorMessage = nil
    }

    func acceptTerms() {
        // Keeps onboarding active until bio is also completed
    }

    func completeBio() {
        self.hasCompletedOnboarding = true
    }

    func completeOnboarding() {
        self.hasCompletedOnboarding = true
    }

    func logOut() {
        self.isLoggedIn = false
        self.isAuthenticated = false
        self.hasCompletedOnboarding = false
        self.errorMessage = nil
    }
}
