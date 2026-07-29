//
//  SignUpView.swift
//  Community Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss

    // Sign Up steps: 1 = Account Info, 2 = Identity Verification
    @State private var step = 1

    // Loading overlay controls
    @State private var showLoadingScreen = false
    @State private var targetStep = 1
    @State private var isFinalizingSignUp = false

    // Form inputs
    @State private var emailOrPhone = ""
    @State private var fullName = ""
    @State private var idType = "Driver's License"
    @State private var idNumber = ""

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                if step == 1 {
                    // STEP 1: Basic Account Setup
                    VStack(spacing: 16) {
                        Text("Create Your Account")
                            .font(.title2)
                            .bold()

                        Text("Enter your email or phone number to get started.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)

                        TextField("Enter email or phone number", text: $emailOrPhone)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        if let errorMessage = authViewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                        }

                        Button(action: {
                            if emailOrPhone.isEmpty {
                                authViewModel.errorMessage = "Please enter an email or phone number."
                            } else {
                                authViewModel.userEmailOrPhone = emailOrPhone
                                authViewModel.errorMessage = nil
                                transitionToStep(2)
                            }
                        }) {
                            Text("Next: Verify Identity")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                    }
                } else {
                    // STEP 2: Identity Verification & Complete Sign Up
                    ScrollView {
                        VStack(spacing: 16) {
                            Image(systemName: "person.badge.shield.checkmark.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.green)

                            Text("Verify Identity & Join")
                                .font(.title2)
                                .bold()

                            Text("Provide your details to complete setup.")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)

                            TextField("Full Name", text: $fullName)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)

                            HStack {
                                TextField("ID Type", text: $idType)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)

                                TextField("ID Number", text: $idNumber)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }

                            Button(action: {
                                authViewModel.hasUploadedID.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "photo")
                                    Text(authViewModel.hasUploadedID ? "ID Uploaded ✓" : "Upload ID Photo")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(authViewModel.hasUploadedID ? Color.green.opacity(0.2) : Color(.systemGray5))
                                .cornerRadius(8)
                            }

                            if let errorMessage = authViewModel.errorMessage {
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }

                            Button(action: {
                                if fullName.isEmpty || idNumber.isEmpty {
                                    authViewModel.errorMessage = "Please fill in all identity details."
                                } else {
                                    authViewModel.userFullName = fullName
                                    authViewModel.userIDType = idType
                                    authViewModel.userIDNumber = idNumber
                                    authViewModel.errorMessage = nil

                                    isFinalizingSignUp = true
                                    withAnimation {
                                        showLoadingScreen = true
                                    }
                                }
                            }) {
                                Text("Sign Up")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(8)
                            }

                            // BACK BUTTON (From Step 2 -> Step 1)
                            Button(action: {
                                withAnimation {
                                    step = 1
                                }
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Back to Step 1")
                                }
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.top, 4)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)

            // Sign Up Loading Overlay
            if showLoadingScreen {
                LoadingView(mode: .signUp, isLoading: $showLoadingScreen) {
                    if isFinalizingSignUp {
                        // Triggers auth state and forces Terms & Policies screen next
                        authViewModel.finalizeSignUp(fullName: fullName, idType: idType, idNumber: idNumber)
                    } else {
                        step = targetStep
                    }
                }
                .transition(.opacity)
            }
        }
    }

    private func transitionToStep(_ nextStep: Int) {
        targetStep = nextStep
        isFinalizingSignUp = false
        withAnimation {
            showLoadingScreen = true
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}
