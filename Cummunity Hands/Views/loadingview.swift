//
//  loadingview.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/28/26.
//

import SwiftUI

enum LoadingMode {
    case welcome
    case login
    case signUp
}

struct LoadingView: View {
    let mode: LoadingMode
    @Binding var isLoading: Bool
    var onComplete: () -> Void

    @State private var bounceOffset: CGFloat = -10
    @State private var isCompletedStage: Bool = false
    @State private var progressText: String = ""

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

                    if mode == .welcome {
                        // WELCOME ANIMATION
                        if !isCompletedStage {
                            // Stage 1: Joining hands / Community icon
                            Image(systemName: "hand.raised.hands.fill")
                                .font(.system(size: 55))
                                .foregroundColor(.green)
                                .offset(y: bounceOffset)
                        } else {
                            // Stage 2: Welcome heart / community emblem
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 65))
                                .foregroundColor(.green)
                                .transition(.scale.combined(with: .opacity))
                        }
                    } else if mode == .login {
                        // LOG IN ANIMATION
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
                    } else {
                        // SIGN UP ANIMATION
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
                    }
                }

                // Dynamic Message
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
            setupInitialText()
            startAnimationSequence()
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
        }
    }

    private func startAnimationSequence() {
        // Step 1: Gentle bounce animation
        withAnimation(Animation.easeInOut(duration: 0.5).repeatCount(4, autoreverses: true)) {
            bounceOffset = 10
        }

        // Step 2: Transition to completion stage
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(.spring()) {
                isCompletedStage = true
                switch mode {
                case .welcome:
                    progressText = "Connecting you to your neighborhood..."
                case .login:
                    progressText = "Identity verified! Opening dashboard..."
                case .signUp:
                    progressText = "Handing garden supplies to customer..."
                }
            }
        }

        // Step 3: Finish loading and transition screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeOut(duration: 0.4)) {
                isLoading = false
                onComplete()
            }
        }
    }
}

#Preview {
    LoadingView(mode: .welcome, isLoading: .constant(true), onComplete: {})
}
