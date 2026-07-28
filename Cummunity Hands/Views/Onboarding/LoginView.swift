//
//  LoginView.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var input = ""

    var body: some View {
        VStack(spacing: 20) {
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
                authViewModel.logIn(emailOrPhone: input)
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
