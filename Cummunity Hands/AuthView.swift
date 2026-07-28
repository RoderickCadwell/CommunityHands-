//
//  AuthView.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import SwiftUI

struct AuthView: View {
    @State private var isSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var isAdult = false
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 8) {
                Image(systemName: "hand.raised.hands.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.black)
                
                Text("Community Hands")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Help your neighborhood. Earn on your terms.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()

            VStack(spacing: 16) {
                if isSignUp {
                    TextField("Full Name", text: $fullName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    Toggle("I am 18 or older (Unlocks Hourly Jobs)", isOn: $isAdult)
                        .padding(.horizontal, 4)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                TextField("Email Address", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Button(action: {
                isLoggedIn = true
            }) {
                Text(isSignUp ? "Create Account" : "Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Button(action: { isSignUp.toggle() }) {
                Text(isSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                    .font(.footnote)
                    .foregroundColor(.black)
                    .bold()
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    AuthView()
}
