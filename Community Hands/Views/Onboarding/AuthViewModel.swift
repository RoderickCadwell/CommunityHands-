//
//  AuthViewModel.swift
//  Cummunity Hands
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("hasAcceptedTerms") var hasAcceptedTerms: Bool = false
    @AppStorage("hasCompletedBio") var hasCompletedBio: Bool = false

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

    // Direct Login -> Bypasses Terms & Bio, goes straight to Main/Listings
    func logIn(emailOrPhone: String) {
        self.userEmailOrPhone = emailOrPhone
        self.isLoggedIn = true
        self.isAuthenticated = true
        self.hasAcceptedTerms = true
        self.hasCompletedBio = true
        self.errorMessage = nil
    }

    func login() {
        self.isLoggedIn = true
        self.isAuthenticated = true
        self.hasAcceptedTerms = true
        self.hasCompletedBio = true
        self.errorMessage = nil
    }

    // Sign Up -> Forces full onboarding sequence
    func signUp() {
        self.isLoggedIn = true
        self.isAuthenticated = true
        self.hasAcceptedTerms = false
        self.hasCompletedBio = false
        self.errorMessage = nil
    }

    func finalizeSignUp(fullName: String, idType: String, idNumber: String) {
        self.userFullName = fullName
        self.userIDType = idType
        self.userIDNumber = idNumber
        self.isLoggedIn = true
        self.isAuthenticated = true
        self.hasAcceptedTerms = false
        self.hasCompletedBio = false
        self.errorMessage = nil
    }

    func acceptTerms() {
        self.hasAcceptedTerms = true
    }

    func completeBio() {
        self.hasCompletedBio = true
    }

    func logOut() {
        self.isLoggedIn = false
        self.isAuthenticated = false
        self.hasAcceptedTerms = false
        self.hasCompletedBio = false
        self.errorMessage = nil
    }
}
