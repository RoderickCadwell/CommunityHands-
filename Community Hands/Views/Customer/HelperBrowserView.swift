//
//  HelperBrowserView.swift
//  Community Hands
//
//  Created by JOURNi Student on 8/1/26.
//

import SwiftUI
import SwiftData

// MARK: - Helper Browser View
// Allows homeowners to browse available teen helpers
// Shows ratings, skills, and completed jobs
struct HelperBrowserView: View {
    // MARK: - Environment
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Query
    // Fetch teen helpers (users with isTeen = true)
    @Query(filter: #Predicate<User> { $0.isTeen == true }) private var teenHelpers: [User]
    
    // MARK: - State
    @State private var searchText: String = ""
    @State private var selectedSkill: String? = nil
    
    // MARK: - Skills Filter
    private let availableSkills = [
        "All",
        "Lawn Care",
        "Pet Care",
        "Babysitting",
        "Car Wash",
        "Tutoring",
        "House Cleaning"
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Search Bar
                TextField("Search helpers...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                // MARK: - Skills Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(availableSkills, id: \.self) { skill in
                            SkillFilterButton(
                                skill: skill,
                                isSelected: selectedSkill == skill || (skill == "All" && selectedSkill == nil)
                            ) {
                                selectedSkill = skill == "All" ? nil : skill
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // MARK: - Helper List
                List {
                    ForEach(filteredHelpers) { helper in
                        HelperRowView(helper: helper)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Find Helpers")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Filtered Helpers
    private var filteredHelpers: [User] {
        var filtered = teenHelpers
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.fullName.localizedCaseInsensitiveContains(searchText) ||
                ($0.bio?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        // Filter by skill
        if let skill = selectedSkill {
            filtered = filtered.filter {
                $0.bio?.localizedCaseInsensitiveContains(skill) ?? false
            }
        }
        
        return filtered
    }
}

// MARK: - Skill Filter Button
struct SkillFilterButton: View {
    let skill: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(skill)
                .font(.caption)
                .fontWeight(isSelected ? .bold : .regular)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? Color("primaryComHandColor") : Color.gray.opacity(0.2))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

// MARK: - Helper Row View
struct HelperRowView: View {
    let helper: User
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar - check for non-empty string, not just non-nil
            if let avatarName = helper.avatarImageName, !avatarName.isEmpty {
                Image(avatarName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .accessibilityHidden(true)
            } else {
                // Initials fallback
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Text(helper.fullName.prefix(2).uppercased())
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(helper.fullName)
                    .font(.headline)
                
                if let age = helper.age {
                    Text("Age \(age)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let bio = helper.bio {
                    Text(bio)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview {
    HelperBrowserView()
        .modelContainer(for: User.self, inMemory: true)
}
