//
//  loadingview.swift
//  Community Hands
//
//  Created by JOURNi Student on 7/28/26.
//

import SwiftUI

enum LoadingMode {
    case welcome
    case login
    case signUp
    case menuings
    case schedule
    case acceptJob
}

struct LoadingView: View {
    let mode: LoadingMode
    @Binding var isLoading: Bool
    var onComplete: () -> Void

    @State private var bounceOffset: CGFloat = -10
    @State private var isCompletedStage: Bool = false
    @State private var progressText: String = ""
    @State private var animationSequenceTask: Task<Void, Never>?
    @State private var activeSequenceID: UUID = UUID()

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                // Animated Green Circle Indicator
                ZStack {
                    Circle()
                        .stroke(Color.green, lineWidth: 6)
                        .frame(width: 170, height: 170)

                    Circle()
                        .fill(Color.green.opacity(0.15))
                        .frame(width: 160, height: 160)

                    switch mode {
                    case .welcome:
                        if !isCompletedStage {
                            Image(systemName: "hand.raised.hands.fill")
                                .font(.system(size: 55))
                                .foregroundColor(.green)
                                .offset(y: bounceOffset)
                        } else {
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 65))
                                .foregroundColor(.green)
                                .transition(.scale.combined(with: .opacity))
                        }

                    case .login:
                        if !isCompletedStage {
                            Image(systemName: "shield.bordercheck")
                                .font(.system(size: 50))
                                .foregroundColor(.green)
                                .offset(y: bounceOffset)
                        } else {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                                .transition(.scale.combined(with: .opacity))
                        }

                    case .signUp:
                        if !isCompletedStage {
                            HStack(spacing: 6) {
                                Image(systemName: "figure.walk")
                                    .font(.system(size: 45))
                                    .foregroundColor(.black)
                                    .offset(y: bounceOffset)

                                Image(systemName: "bag.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                            }
                        } else {
                            HStack(spacing: 8) {
                                Image(systemName: "figure.walk")
                                    .font(.system(size: 40))
                                    .foregroundColor(.black)

                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.green)

                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.black)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }

                    case .menuings:
                        if !isCompletedStage {
                            Image(systemName: "list.bullet.clipboard.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.green)
                                .offset(y: bounceOffset)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                                .transition(.scale.combined(with: .opacity))
                        }

                    case .schedule:
                        if !isCompletedStage {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 50))
                                .foregroundColor(.green)
                                .offset(y: bounceOffset)
                        } else {
                            Image(systemName: "calendar.badge.checkmark")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                                .transition(.scale.combined(with: .opacity))
                        }

                    case .acceptJob:
                        if !isCompletedStage {
                            Image(systemName: "hand.thumbsup.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.green)
                                .offset(y: bounceOffset)
                        } else {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                }

                // Dynamic Progress Message
                Text(progressText)
                    .font(.headline)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)

                Spacer()
            }
        }
        .onAppear {
            animationSequenceTask?.cancel()
            animationSequenceTask = nil
            activeSequenceID = UUID()
            isCompletedStage = false
            bounceOffset = -10
            setupInitialText()
            startAnimationSequence()
        }
        .onDisappear {
            animationSequenceTask?.cancel()
            animationSequenceTask = nil
        }
    }

    private func setupInitialText() {
        switch mode {
        case .welcome:
            progressText = "Welcome to a hands-on community"
        case .login:
            progressText = "Verifying account credentials..."
        case .signUp:
            progressText = "Preparing local community supplies..."
        case .menuings:
            progressText = "Loading local neighborhood jobs..."
        case .schedule:
            progressText = "Syncing your job calendar..."
        case .acceptJob:
            progressText = "Confirming job assignment with client..."
        }
    }

    private func startAnimationSequence() {
        let sequenceID = activeSequenceID
        animationSequenceTask?.cancel()

        animationSequenceTask = Task { @MainActor in
            guard !Task.isCancelled, activeSequenceID == sequenceID else { return }

            // Step 1: Gentle bounce animation
            withAnimation(Animation.easeInOut(duration: 0.5).repeatCount(4, autoreverses: true)) {
                bounceOffset = 10
            }

            try? await Task.sleep(nanoseconds: UInt64(1.6 * 1_000_000_000))
            guard !Task.isCancelled, activeSequenceID == sequenceID else { return }

            // Step 2: Transition to completion stage
            withAnimation(.spring()) {
                isCompletedStage = true
                switch mode {
                case .welcome:
                    progressText = "Connecting you to your neighborhood..."
                case .login:
                    progressText = "Identity verified! Opening dashboard..."
                case .signUp:
                    progressText = "Handing garden supplies to customer..."
                case .menuings:
                    progressText = "Jobs ready for East Village & Highland Park!"
                case .schedule:
                    progressText = "Schedule updated successfully!"
                case .acceptJob:
                    progressText = "Job accepted! Details sent to client."
                }
            }

            try? await Task.sleep(nanoseconds: UInt64(1.4 * 1_000_000_000))
            guard !Task.isCancelled, activeSequenceID == sequenceID else { return }

            // Step 3: Finish loading and transition screen
            withAnimation(.easeOut(duration: 0.4)) {
                isLoading = false
                onComplete()
            }
        }
    }
}

#Preview {
    LoadingView(mode: .menuings, isLoading: .constant(true), onComplete: {})
}
