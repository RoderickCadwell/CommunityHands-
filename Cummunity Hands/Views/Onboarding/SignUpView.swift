//
//  SignUpView.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    // Steps: 1 = Waiver, 2 = Contact Info, 3 = ID Verify, 4 = Bio & Profile Photo
    @State private var step = 1
    @State private var hasAcceptedWaiver = false

    // Loading overlay controls
    @State private var showLoadingScreen = false
    @State private var targetStep = 1

    // Form inputs
    @State private var contactInput = ""
    @State private var fullName = ""
    @State private var idType = "Driver's License"
    @State private var idNumber = ""
    
    // Step 4 Bio inputs
    @State private var bioText = "Hi, I'm a local community member looking to hire trusted neighborhood helpers for everyday tasks around the house."
    @State private var isCustomImageAttached = false

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                // STEP 1: Waiver, Terms & Policy Screen
                if step == 1 {
                    VStack(spacing: 12) {
                        Text("User Agreement & Waiver")
                            .font(.title2)
                            .bold()
                            .padding(.vertical, 6)
                            .padding(.horizontal, 16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.black, lineWidth: 2)
                            )

                        ScrollView {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Community Hands User Agreement, Liability Waiver, and Release of Claims")
                                    .font(.headline)
                                    .bold()
                                    .padding(.bottom, 2)

                                Group {
                                    Text("1. About Community Hands").font(.subheadline).bold()
                                    Text("Community Hands is a platform connecting individuals seeking help with everyday tasks (\"Clients\") and teenagers or other approved users (\"Helpers\") willing to perform those tasks in their local communities.")

                                    Text("2. Eligibility").font(.subheadline).bold()
                                    Text("Users must meet minimum age requirements. Helpers under 18 must have verified parental or legal guardian consent before creating an account.")

                                    Text("3. Assumption of Risk").font(.subheadline).bold()
                                    Text("By using Community Hands, you voluntarily assume all risks associated with participating in services arranged through the App.")

                                    Text("4. Release of Liability").font(.subheadline).bold()
                                    Text("To the fullest extent permitted by law, you release and hold harmless Community Hands from any claims arising from services arranged through the platform.")
                                }
                            }
                            .font(.caption)
                            .foregroundColor(.primary)
                            .padding()
                        }
                        .frame(maxHeight: 280)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )

                        Toggle(isOn: $hasAcceptedWaiver) {
                            Text("I agree to the User Agreement, Liability Waiver, and Release of Claims")
                                .font(.caption2)
                                .bold()
                        }
                        .padding(.horizontal, 4)

                        Button(action: {
                            if hasAcceptedWaiver {
                                authViewModel.errorMessage = nil
                                transitionToStep(2)
                            } else {
                                authViewModel.errorMessage = "You must accept the terms & waiver to continue."
                            }
                        }) {
                            Text("Continue")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.black)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                        }
                        .opacity(hasAcceptedWaiver ? 1.0 : 0.5)
                    }
                }
                
                // STEP 2: Email or Phone Number Screen
                else if step == 2 {
                    VStack(spacing: 16) {
                        Text("What's your email or phone number?")
                            .font(.headline)
                            .multilineTextAlignment(.center)

                        TextField("Enter email or phone number", text: $contactInput)
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
                            if contactInput.isEmpty {
                                authViewModel.errorMessage = "Please enter an email or phone number."
                            } else {
                                authViewModel.userEmailOrPhone = contactInput
                                authViewModel.errorMessage = nil
                                transitionToStep(3)
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

                        Button("Back to Agreement") {
                            step = 1
                        }
                        .font(.footnote)
                        .foregroundColor(.gray)
                    }
                }
                
                // STEP 3: Identity Verification Screen
                else if step == 3 {
                    ScrollView {
                        VStack(spacing: 16) {
                            Image(systemName: "doc.text.magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.blue)

                            Text("Verify your identity")
                                .font(.title2)
                                .bold()

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
                                    Text(authViewModel.hasUploadedID ? "ID Uploaded ✓" : "Upload / Take a Photo of ID")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(authViewModel.hasUploadedID ? Color.green.opacity(0.2) : Color(.systemGray5))
                                .cornerRadius(8)
                            }

                            Button(action: {
                                if fullName.isEmpty || idNumber.isEmpty {
                                    authViewModel.errorMessage = "Please fill in all identity fields."
                                } else {
                                    authViewModel.errorMessage = nil
                                    transitionToStep(4)
                                }
                            }) {
                                Text("Next: Profile & Bio")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(8)
                            }
                            
                            Button("Back") {
                                step = 2
                            }
                            .font(.footnote)
                            .foregroundColor(.gray)
                        }
                    }
                }

                // STEP 4: Customer Profile Picture & Bio Screen
                else {
                    VStack(spacing: 20) {
                        Text("Customer Bio & Profile")
                            .font(.title2)
                            .bold()

                        VStack(spacing: 8) {
                            ZStack(alignment: .bottomTrailing) {
                                Circle()
                                    .fill(Color(.systemGray5))
                                    .frame(width: 130, height: 130)
                                    .overlay(
                                        Image(systemName: isCustomImageAttached ? "person.crop.circle.fill" : "person.fill.viewfinder")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(20)
                                            .foregroundColor(.black)
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(Color.black, lineWidth: 3)
                                    )

                                Button(action: {
                                    isCustomImageAttached.toggle()
                                }) {
                                    Image(systemName: "paperclip.circle.fill")
                                        .resizable()
                                        .frame(width: 36, height: 36)
                                        .foregroundColor(.green)
                                        .background(Color.white.clipShape(Circle()))
                                }
                            }

                            Text(isCustomImageAttached ? "Custom Photo Attached" : "Pre-selected Senior Profile Photo")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Customer Bio:")
                                .font(.headline)

                            TextEditor(text: $bioText)
                                .frame(height: 120)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1.5)
                                )
                        }

                        Button(action: {
                            authViewModel.finalizeSignUp(
                                fullName: fullName,
                                idType: idType,
                                idNumber: idNumber
                            )
                        }) {
                            Text("Continue")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.black)
                                .padding(.horizontal, 36)
                                .padding(.vertical, 10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                        }

                        Button("Back to ID Verification") {
                            step = 3
                        }
                        .font(.footnote)
                        .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)

            // Distinct Sign Up Loading Overlay
            if showLoadingScreen {
                LoadingView(mode: .signUp, isLoading: $showLoadingScreen) {
                    step = targetStep
                }
                .transition(.opacity)
            }
        }
    }

    private func transitionToStep(_ nextStep: Int) {
        targetStep = nextStep
        withAnimation {
            showLoadingScreen = true
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}
