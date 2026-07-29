//
//  TermsAndPoliciesView.swift
//  Community Hands
//
//  Created by JOURNi Student on 7/29/26.
//

import SwiftUI

struct TermsAndPoliciesView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // Navigation state to open CustomerBioView next
    @State private var navigateToBio: Bool = false
    
    // User signature inputs
    @State private var printedName: String = ""
    @State private var electronicSignature: String = ""
    @State private var parentSignature: String = ""
    @State private var isUnder18: Bool = false
    
    // Checkbox agreement state
    @State private var hasAgreed: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // MARK: - Header Bar
                HStack {
                    Button(action: {
                        authViewModel.logOut()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.body)
                        .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    Text("Terms & Waiver")
                        .font(.headline)
                        .bold()
                    
                    Spacer()
                    
                    Text("Back")
                        .font(.body)
                        .opacity(0)
                }
                .padding()
                .background(Color(.systemBackground))
                
                Divider()

                // MARK: - Terms Content & Agreement Form
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        VStack(alignment: .center, spacing: 8) {
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.green)
                                .padding(.top, 8)

                            Text("Community Hands User Agreement, Liability Waiver, and Release of Claims")
                                .font(.title3)
                                .bold()
                                .multilineTextAlignment(.center)

                            Text("Effective Date: \(Date().formatted(date: .long, time: .omitted))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 6)

                        Text("Welcome to Community Hands. By creating an account or using the Community Hands platform (\"App\"), you acknowledge that you have read, understood, and agreed to the following terms.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        // Legal Sections 1 through 17
                        Group {
                            sectionBlock(title: "1. About Community Hands", text: "Community Hands is a platform that connects individuals seeking help with everyday tasks (\"Clients\") and teenagers or other approved users (\"Helpers\") willing to perform those tasks in their local communities.\n\nCommunity Hands is only a marketplace. We do not employ Helpers, supervise jobs, or guarantee the quality, safety, or completion of any service.")
                            
                            sectionBlock(title: "2. Eligibility", text: "• Users must meet the minimum age requirements established by Community Hands.\n• Helpers under the age of 18 must have verified parental or legal guardian consent before creating an account.\n• Parents or guardians are responsible for monitoring their minor's participation on the platform.")

                            sectionBlock(title: "3. Assumption of Risk", text: "By using Community Hands, you voluntarily assume all risks associated with participating in services arranged through the App. These risks include, but are not limited to:\n\n• Personal injury\n• Property damage\n• Theft\n• Accidents\n• Transportation-related incidents\n• Weather-related hazards\n• Animal-related injuries\n• Misunderstandings between users\n• Financial loss\n\nYou acknowledge that no platform can eliminate every possible risk.")

                            sectionBlock(title: "4. Independent Users", text: "Helpers are independent individuals and are not employees, contractors, agents, or representatives of Community Hands. Clients choose Helpers at their own discretion. Community Hands does not supervise, direct, or control how work is completed.")

                            sectionBlock(title: "5. No Guarantee of Background Checks", text: "Although Community Hands may verify certain account information, the platform does not guarantee:\n\n• Criminal history\n• Identity\n• Experience\n• Licensing\n• Skill level\n• Character\n• Reliability\n\nUsers are responsible for exercising good judgment before accepting or requesting services.")

                            sectionBlock(title: "6. Parent and Guardian Consent", text: "If a Helper is under 18 years old:\n\n• A parent or legal guardian must approve the account.\n• The parent acknowledges the risks involved with performing neighborhood work.\n• The parent accepts responsibility for supervising the minor's use of the App.")

                            sectionBlock(title: "7. Safety Rules", text: "Community Hands strongly encourages all users to:\n\n• Meet in safe, public, or visible locations whenever possible.\n• Never enter a home unless a parent or guardian has approved.\n• Avoid jobs that involve dangerous tools, chemicals, roofing, electrical work, or hazardous equipment.\n• Report suspicious behavior immediately.\n• Contact emergency services in emergencies.")
                        }

                        Group {
                            sectionBlock(title: "8. Payments", text: "Community Hands processes payments through approved payment providers. Community Hands is not responsible for:\n\n• Payment disputes\n• Chargebacks\n• Tips\n• Taxes\n• Failure to complete work\n• Pricing disagreements")

                            sectionBlock(title: "9. Property Damage", text: "Clients understand that accidents may happen during household work. Helpers agree to perform work carefully.\n\nCommunity Hands is not liable for damage to homes, landscaping, vehicles, personal belongings, equipment, or pets. Any disputes regarding damages must be resolved directly between the Client and the Helper.")

                            sectionBlock(title: "10. Release of Liability", text: "To the fullest extent permitted by law, you release, waive, and discharge Community Hands, its founders, owners, employees, officers, directors, affiliates, volunteers, and partners from any and all claims arising from injury, death, property damage, financial losses, emotional distress, negligence of another user, or services arranged through the platform. This release applies whether the claim is known or unknown.")

                            sectionBlock(title: "11. Indemnification", text: "You agree to defend, indemnify, and hold harmless Community Hands from any claims, lawsuits, damages, attorney fees, or expenses resulting from your use of the platform, your violation of these Terms, your interactions with another user, or services you perform or request.")

                            sectionBlock(title: "12. Insurance", text: "Community Hands does not provide health insurance, workers' compensation, automobile insurance, liability insurance, or property insurance. Users are responsible for obtaining any insurance they believe is necessary.")

                            sectionBlock(title: "13. Prohibited Activities", text: "Users may not perform illegal work, request illegal services, harass or threaten other users, discriminate, share false information, circumvent payment through the App when prohibited, or use the platform for scams or fraudulent activities. Violations may result in immediate account suspension or permanent removal.")

                            sectionBlock(title: "14. Account Suspension", text: "Community Hands reserves the right to suspend or permanently terminate any account that violates these Terms or poses a safety risk to the community.")

                            sectionBlock(title: "15. Privacy", text: "Community Hands collects certain information to operate the platform. By using the App, you consent to the collection and use of information as described in the Community Hands Privacy Policy.")

                            sectionBlock(title: "16. Governing Law", text: "These Terms shall be governed by the laws of the jurisdiction in which Community Hands operates, without regard to conflict of law principles.")

                            sectionBlock(title: "17. Changes to These Terms", text: "Community Hands may update these Terms at any time. Continued use of the App after changes become effective constitutes acceptance of the revised Terms.")
                        }

                        Divider()
                            .padding(.vertical, 8)

                        // MARK: - Electronic Signature Fields
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Electronic Agreement & Signatures")
                                .font(.headline)
                            
                            Text("By signing below and checking the agreement box, you acknowledge that you have read this Agreement, understand the risks involved, and voluntarily agree to these terms.")
                                .font(.footnote)
                                .foregroundColor(.secondary)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("User Name (Printed)")
                                    .font(.caption)
                                    .bold()
                                TextField("Enter Full Name", text: $printedName)
                                    .padding(10)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Signature (Electronic)")
                                    .font(.caption)
                                    .bold()
                                TextField("Type full legal name to sign", text: $electronicSignature)
                                    .padding(10)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }

                            Toggle(isOn: $isUnder18.animation()) {
                                Text("I am a Helper under 18 years old")
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 4)

                            if isUnder18 {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Parent/Guardian Electronic Signature (Required)")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.green)
                                    TextField("Parent / Legal Guardian Full Name", text: $parentSignature)
                                        .padding(10)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                }
                                .transition(.opacity)
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                    .padding()
                }

                Divider()

                // MARK: - Footer (Checkbox & Accept Button)
                VStack(spacing: 14) {
                    Button(action: {
                        withAnimation {
                            hasAgreed.toggle()
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: hasAgreed ? "checkmark.square.fill" : "square")
                                .font(.title2)
                                .foregroundColor(hasAgreed ? .green : .gray)
                            
                            Text("I have read and agree to the Community Hands User Agreement, Liability Waiver, and Release of Claims.")
                                .font(.footnote)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.horizontal)

                    Button(action: {
                        authViewModel.acceptTerms()
                        navigateToBio = true
                    }) {
                        Text("Accept & Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.green : Color.gray.opacity(0.5))
                            .cornerRadius(10)
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal)
                }
                .padding(.vertical, 12)
                .background(Color(.systemGroupedBackground))
            }
            .navigationDestination(isPresented: $navigateToBio) {
                CustomerBioView()
            }
        }
    }

    private func sectionBlock(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var isFormValid: Bool {
        let baseValid = hasAgreed && !printedName.isEmpty && !electronicSignature.isEmpty
        if isUnder18 {
            return baseValid && !parentSignature.isEmpty
        }
        return baseValid
    }
}

#Preview {
    TermsAndPoliciesView()
        .environmentObject(AuthViewModel())
}
