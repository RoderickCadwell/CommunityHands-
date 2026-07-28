//
//  MainDashboardView.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import SwiftUI
import SwiftData

struct MainDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JobItem.dateCreated, order: .reverse) private var activeJobs: [JobItem]
    
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    @State private var selectedJobType: JobType = .lawnMowing
    @State private var distanceMiles: Double = 3.5
    @State private var durationHours: Double = 2.0
    @State private var isHourly: Bool = false
    @State private var paymentType: PaymentType = .fixedWithPendingFee

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Community Hands")
                                .font(.title2)
                                .bold()
                            Text("Nearby Opportunities")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: { isLoggedIn = false }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 18) {
                    Text("Select Service")
                        .font(.headline)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(JobType.allCases, id: \.self) { type in
                                CategoryCard(
                                    title: type.rawValue,
                                    isSelected: selectedJobType == type,
                                    icon: iconForType(type)
                                )
                                .onTapGesture {
                                    selectedJobType = type
                                }
                            }
                        }
                    }

                    Divider()

                    VStack(spacing: 12) {
                        HStack {
                            Text("Distance:")
                            Spacer()
                            Text("\(distanceMiles, specifier: "%.1f") miles")
                                .bold()
                        }
                        Slider(value: $distanceMiles, in: 0.5...20.0, step: 0.5)

                        HStack {
                            Text("Est. Duration:")
                            Spacer()
                            Text("\(durationHours, specifier: "%.1f") hrs")
                                .bold()
                        }
                        Slider(value: $durationHours, in: 0.5...8.0, step: 0.5)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Hourly Rate (Adult / Complex Work)", isOn: $isHourly)
                            .font(.subheadline)

                        Picker("Payment Method", selection: $paymentType) {
                            Text("Pending Fee").tag(PaymentType.fixedWithPendingFee)
                            Text("Pay On-Site").tag(PaymentType.payOnSite)
                            if isHourly {
                                Text("Hourly").tag(PaymentType.hourly)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    let calculatedPrice = calculatePrice(
                        distance: distanceMiles,
                        duration: durationHours,
                        hourly: isHourly
                    )

                    HStack {
                        VStack(alignment: .leading) {
                            Text("Estimated Total")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("$\(calculatedPrice, specifier: "%.2f")")
                                .font(.title)
                                .bold()
                        }
                        Spacer()

                        Button(action: createJobRequest) {
                            Text("Request Job")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.black)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .shadow(radius: 5)
            }
        }
    }

    private func calculatePrice(distance: Double, duration: Double, hourly: Bool) -> Double {
        let distanceCost = distance * 1.50
        if hourly {
            return distanceCost + (20.0 * duration)
        } else {
            return distanceCost + 10.0 + (duration * 12.0)
        }
    }

    private func createJobRequest() {
        let newJob = JobItem(
            title: selectedJobType.rawValue,
            jobType: selectedJobType,
            estimatedDurationHours: durationHours,
            distanceMiles: distanceMiles,
            isHourly: isHourly,
            paymentType: paymentType
        )
        modelContext.insert(newJob)
    }

    private func iconForType(_ type: JobType) -> String {
        switch type {
        case .lawnMowing: return "leaf.fill"
        case .snowShoveling: return "snowflake"
        case .diyWork: return "hammer.fill"
        case .eventPlanning: return "calendar"
        case .communityCleanup: return "trash.fill"
        }
    }
}
