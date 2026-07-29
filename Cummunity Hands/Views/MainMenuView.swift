//
//  MainMenuView.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/29/26.
//

import SwiftUI

// Local model definition inside file
struct LocalJob {
    let clientName: String
    let clientImageName: String
    let taskDescription: String
    let payout: Double
    let distanceMiles: Double
}

struct MainMenuView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    // UI & Navigation States
    @State private var isSearchingForWork = true
    @State private var showJobListings = false

    // Loading overlay controls
    @State private var showLoadingScreen = false
    @State private var loadingMode: LoadingMode = .menuings
    @State private var onLoadingComplete: (() -> Void)? = nil

    // Sample Job Data
    @State private var currentJob = LocalJob(
        clientName: "John",
        clientImageName: "person.crop.circle.fill",
        taskDescription: "Needs help with yard work.",
        payout: 22.89,
        distanceMiles: 1.0
    )

    var body: some View {
        NavigationStack {
            ZStack {
                // Mock Canvas Map Component
                MockMapView()
                    .ignoresSafeArea()

                VStack {
                    // Header Status Banner
                    if isSearchingForWork {
                        HStack {
                            Spacer()
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 10, height: 10)
                                Text("Finding work between Highland Park & East Village...")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.black.opacity(0.8))
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(Color.white.opacity(0.92))
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
                            Spacer()
                        }
                        .padding(.top, 10)
                    }

                    Spacer()

                    // Job Offer Card
                    if isSearchingForWork {
                        VStack(spacing: 16) {
                            Text(currentJob.clientName)
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.black)

                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 110, height: 110)
                                .foregroundColor(.gray)

                            Text(currentJob.taskDescription)
                                .font(.title2)
                                .bold()
                                .multilineTextAlignment(.center)

                            Text("$\(String(format: "%.2f", currentJob.payout))")
                                .font(.system(size: 32, weight: .bold))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.black, lineWidth: 3)
                                )

                            // Action Bar
                            VStack(spacing: 8) {
                                HStack(spacing: 20) {
                                    Button(action: {
                                        triggerLoading(.acceptJob) {
                                            isSearchingForWork = false
                                        }
                                    }) {
                                        Text("Accept")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 8)
                                            .background(Color.green)
                                            .cornerRadius(6)
                                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black, lineWidth: 2))
                                    }

                                    Button(action: {
                                        isSearchingForWork = false
                                    }) {
                                        Text("Decline")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 8)
                                            .background(Color.red)
                                            .cornerRadius(6)
                                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black, lineWidth: 2))
                                    }
                                }

                                Text("\(String(format: "%.0f", currentJob.distanceMiles)) Mile away")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(red: 0.45, green: 0.75, blue: 0.35))
                            .cornerRadius(12)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 8)
                        .padding(.horizontal, 20)
                    }

                    Spacer()

                    // Bottom Navigation Bar
                    HStack {
                        Button(action: {
                            triggerLoading(.schedule) {}
                        }) {
                            HStack {
                                Image(systemName: "calendar")
                                    .font(.title2)
                                Text("Schedule Your Jobs")
                                    .font(.headline)
                                    .bold()
                            }
                            .foregroundColor(.white)
                            .padding()
                        }

                        Spacer()

                        Button(action: {
                            if !isSearchingForWork {
                                triggerLoading(.menuings) {
                                    showJobListings = true
                                }
                            } else {
                                isSearchingForWork = false
                            }
                        }) {
                            Text(isSearchingForWork ? "Cancel" : "Find Jobs")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .overlay(Rectangle().stroke(Color.white, lineWidth: 2))
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .background(Color(red: 0.3, green: 0.7, blue: 0.25))
                }

                // Loading Overlay
                if showLoadingScreen {
                    LoadingView(mode: loadingMode, isLoading: $showLoadingScreen) {
                        onLoadingComplete?()
                    }
                    .transition(.opacity)
                }
            }
            .sheet(isPresented: $showJobListings) {
                JobListingsView()
            }
        }
    }

    private func triggerLoading(_ mode: LoadingMode, completion: @escaping () -> Void) {
        loadingMode = mode
        onLoadingComplete = completion
        withAnimation {
            showLoadingScreen = true
        }
    }
}

// Mock Map Canvas Component
struct MockMapView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Terrain
                Color(red: 0.93, green: 0.95, blue: 0.91)

                // Detroit River Curve Representation
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height * 0.85))
                    path.addCurve(
                        to: CGPoint(x: geometry.size.width, y: geometry.size.height * 0.75),
                        control1: CGPoint(x: geometry.size.width * 0.4, y: geometry.size.height * 0.95),
                        control2: CGPoint(x: geometry.size.width * 0.7, y: geometry.size.height * 0.70)
                    )
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
                    path.closeSubpath()
                }
                .fill(Color(red: 0.70, green: 0.82, blue: 0.92))

                // Mock Road Grid
                Path { path in
                    path.move(to: CGPoint(x: 50, y: 50))
                    path.addLine(to: CGPoint(x: geometry.size.width - 50, y: geometry.size.height - 150))

                    path.move(to: CGPoint(x: 0, y: geometry.size.height * 0.4))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height * 0.45))
                }
                .stroke(Color.white, lineWidth: 8)

                // Route Line between Highland Park and East Village
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width * 0.28, y: geometry.size.height * 0.22))
                    path.addQuadCurve(
                        to: CGPoint(x: geometry.size.width * 0.74, y: geometry.size.height * 0.48),
                        control: CGPoint(x: geometry.size.width * 0.5, y: geometry.size.height * 0.3)
                    )
                }
                .stroke(Color.green, style: StrokeStyle(lineWidth: 4, dash: [8, 6]))

                // Highland Park Pin
                VStack(spacing: 2) {
                    Text("Highland Park")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.85))
                        .cornerRadius(6)

                    Image(systemName: "mappin.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
                .position(x: geometry.size.width * 0.28, y: geometry.size.height * 0.22)

                // East Village Pin
                VStack(spacing: 2) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)

                    Text("East Village")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.85))
                        .cornerRadius(6)
                }
                .position(x: geometry.size.width * 0.74, y: geometry.size.height * 0.48)
            }
        }
    }
}

#Preview {
    MainMenuView()
        .environmentObject(AuthViewModel())
}
