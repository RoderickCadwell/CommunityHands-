//
//  SignUpView.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var step = 1
    @State private var contactInput = ""
    @State private var fullName = ""
    @State private var idType = "Driver's License"
    @State private var idNumber = ""

    var body: some View {
        VStack(spacing: 20) {
            if step == 1 {
                // STEP 1: Contact Info
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
                            step = 2
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
                        Image(systemName: "doc.text.magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)

                        Text("Verify your identity")
                            .font(.title2)
                            .bold()

                        Text("Please provide your full name and upload a valid ID so we're sure it's you.")
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

                        // Photo Upload Button 1
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

                        // Photo Upload Button 2
                        Button(action: {
                            authViewModel.hasUploadedSelfie.toggle()
                        }) {
                            HStack {
                                Image(systemName: "camera")
                                Text(authViewModel.hasUploadedSelfie ? "Selfie Uploaded ✓" : "Upload / Take a Selfie")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(authViewModel.hasUploadedSelfie ? Color.green.opacity(0.2) : Color(.systemGray5))
                            .cornerRadius(8)
                        }

                        Button(action: {
                            authViewModel.finalizeSignUp(
                                fullName: fullName,
                                idType: idType,
                                idNumber: idNumber
                            )
                        }) {
                            Text("Submit & Create Account")
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
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}
