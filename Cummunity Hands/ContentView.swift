 //
//  ContentView.swift
//  Cummunity Hands//
//  Created by JOURNi Student on 7/27/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some View {
        Group {
            if isLoggedIn {
                MainDashboardView()
            } else {
                AuthView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [JobItem.self, UserProfile.self], inMemory: true)
}
