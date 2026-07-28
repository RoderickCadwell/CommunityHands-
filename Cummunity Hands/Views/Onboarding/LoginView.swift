//
//  LoginView.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    // Login steps: 1 = Contact Info, 2 = Identity Verification
    @State private var step = 1

    // Loading overlay controls
    @State private var showLoadingScreen = false
    @State private var targetStep = 1
    @State private var isFinalizingLogin = false

    // Form inputs
    @State private var input = ""
    @State private var fullName = ""
    @State private var idType = "Driver's License"
    @State private var idNumber = ""

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                if step == 1 {
                    // STEP 1: Enter Email or Phone
                    VStack(spacing: 16) {
                        Text("What's your email or phone number?")
                            .font(.headline)
                            .multilineTextAlignment(.center)

                        TextField("Enter email or phone number", text: $input)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        Button(action: {
                            if input.isEmpty {
                                authViewModel.errorMessage = "Please enter an email or phone number."
                            } else {
                                authViewModel.userEmailOrPhone = input
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
                    // STEP 2: Identity Verification
                    ScrollView {
                        VStack(spacing: 16) {
                            Image(systemName: "checkmark.shield.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.green)

                            Text("Verify Your Identity")
                                .font(.title2)
                                .bold()

                            Text("Confirm your details to sign in securely.")
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
                                    Text(authViewModel.hasUploadedID ? "ID Verified ✓" : "Upload / Confirm Photo ID")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(authViewModel.hasUploadedID ? Color.green.opacity(0.2) : Color(.systemGray5))
                                .cornerRadius(8)
                            }

                            Button(action: {
                                if fullName.isEmpty || idNumber.isEmpty {
                                    authViewModel.errorMessage = "Please fill in your name and ID number."
                                } else {
                                    authViewModel.userFullName = fullName
                                    authViewModel.userIDType = idType
                                    authViewModel.userIDNumber = idNumber
                                    authViewModel.errorMessage = nil
                                    
                                    isFinalizingLogin = true
                                    withAnimation {
                                        showLoadingScreen = true
                                    }
                                }
                            }) {
                                Text("Log In")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(8)
                            }

                            Button("Back") {
                                step = 1
                            }
                            .font(.footnote)
                            .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding(.horizontal)

            // Distinct Log In Loading Overlay
            if showLoadingScreen {
                LoadingView(mode: .login, isLoading: $showLoadingScreen) {
                    if isFinalizingLogin {
                        authViewModel.logIn(emailOrPhone: input)
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
        isFinalizingLogin = false
        withAnimation {
            showLoadingScreen = true
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
