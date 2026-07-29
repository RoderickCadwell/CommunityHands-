//
//  AuthView.swift
//  Community Hands
//
//  Created by JOURNi Student on 7/28/26.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSignUp = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Header Box
            Text("Community Hands")
                .font(.title)
                .bold()
                .foregroundColor(.green)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.black, lineWidth: 1)
                )

            if let error = authViewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            if showSignUp {
                SignUpView()
            } else {
                LoginView()
            }

            Button(action: {
                showSignUp.toggle()
                authViewModel.errorMessage = nil
            }) {
                Text(showSignUp ? "Already registered? Log In" : "Need an account? Sign Up")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.blue)
            }

            Spacer()

            // Bottom Branding Image/Icon
            VStack(spacing: 4) {
                Image(systemName: "house.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.green)

                Text("Community Hands")
                    .font(.caption)
                    .bold()

                Text("WORK. LEARN. EARN. GROW.")
                    .font(.system(size: 8))
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 10)
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}
