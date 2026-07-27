//
//  WelcomeView.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 45) {
                Text("Community Hands")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("primaryColor"))
                Image("logo")
                    .resizable()
                    .frame(width: 250, height: 250)
                
                // Navigation Link to Get Started/SignUpView
                NavigationLink(destination: SignUpView()) {
                    Text("Get Started")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color("primaryColor")))
                        .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 4)
                }
                .padding(30)
                
                // CTA Buttons
                VStack{
                    
                    // Already have an account
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.system(size: 15, weight: .regular))
                        
                        // Link to LoginView
                        NavigationLink(destination: LoginView()) {
                            Text("Log in")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color("primaryColor"))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
