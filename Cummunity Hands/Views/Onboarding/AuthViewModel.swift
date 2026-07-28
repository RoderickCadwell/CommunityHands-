//
//  AuthViewModel.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/28/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("userFullName") var userFullName: String = ""
    @AppStorage("userEmailOrPhone") var userEmailOrPhone: String = ""
    @AppStorage("userIDType") var userIDType: String = ""
    @AppStorage("userIDNumber") var userIDNumber: String = ""
    @AppStorage("hasUploadedID") var hasUploadedID: Bool = false
    @AppStorage("hasUploadedSelfie") var hasUploadedSelfie: Bool = false

    @Published var errorMessage: String? = nil

    init() {}

    // Mock Log In
    func logIn(emailOrPhone: String) {
        if emailOrPhone.isEmpty {
            errorMessage = "Please enter your email or phone number."
            return
        }
        self.userEmailOrPhone = emailOrPhone
        self.isLoggedIn = true
        self.errorMessage = nil
    }

    // Mock Sign Up Finalize
    func finalizeSignUp(fullName: String, idType: String, idNumber: String) {
        if fullName.isEmpty || idType.isEmpty || idNumber.isEmpty {
            errorMessage = "Please complete all fields to verify your identity."
            return
        }
        self.userFullName = fullName
        self.userIDType = idType
        self.userIDNumber = idNumber
        self.isLoggedIn = true
        self.errorMessage = nil
    }

    func logOut() {
        self.isLoggedIn = false
    }
}
