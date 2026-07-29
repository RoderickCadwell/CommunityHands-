//
//  CustomerBioView.swift
//  Community Hands
//
//  Created by JOURNi Student on 7/29/26.
//

import SwiftUI

struct CustomerBioView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var bioText: String = ""
    @State private var selectedRole: String = "Community Member"

    let roles = ["Community Member", "Volunteer", "Local Vendor"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Complete Your Bio")
                    .font(.title)
                    .bold()
                    .padding(.top)

                Text("Tell the community a little bit about yourself.")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Select Your Role")
                        .font(.headline)

                    Picker("Role", selection: $selectedRole) {
                        ForEach(roles, id: \.self) { role in
                            Text(role)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text("Short Bio")
                        .font(.headline)
                        .padding(.top, 10)

                    TextEditor(text: $bioText)
                        .frame(height: 120)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                }
                .padding(.horizontal)

                Spacer()

                Button(action: {
                    // Completes onboarding and routes straight to MainMenuView/Marketplace
                    authViewModel.completeOnboarding()
                }) {
                    Text("Save & Enter Marketplace")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Takes user back to Welcome/Login flow
                        authViewModel.logOut()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.green)
                    }
                }
            }
        }
    }
}

#Preview {
    CustomerBioView()
        .environmentObject(AuthViewModel())
}
