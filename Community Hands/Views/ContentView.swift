//
//  ContentView.swift
//  Community Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                VStack(spacing: 20) {
                    Text("Hello, \(authViewModel.userFullName.isEmpty ? "User" : authViewModel.userFullName)!")
                        .font(.title)
                        .bold()
                    
                    Text("Contact: \(authViewModel.userEmailOrPhone)")
                        .foregroundColor(.gray)
                    
                    Button("Log Out") {
                        authViewModel.logOut()
                    }
                    .padding()
                    .foregroundColor(.red)
                }
            } else {
                AuthView()
            }
        }
        .environmentObject(authViewModel)
    }
}

#Preview {
    ContentView()
}
