//
//  UIComponents.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/27/26.
//

 import SwiftUI

  struct CategoryCard: View {
      let title: String
      let isSelected: Bool
      let icon: String

      var body: some View {
          VStack(spacing: 8) {
             Image(systemName: icon)
                 .font(.title2)
             Text(title)
                 .font(.caption)
                 .fontWeight(.medium)
         }
         .frame(width: 90, height: 80)
         .background(isSelected ? Color.black : Color(.systemGray6))         .foregroundColor(isSelected ? .white : .black)
         .cornerRadius(12)
     }
 }

 extension View {
     func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
         clipShape(RoundedCorner(radius: radius, corners: corners))
     }
 }

 struct RoundedCorner: Shape {
     var radius: CGFloat = .infinity
     var corners: UIRectCorner = .allCorners
     func path(in rect: CGRect) -> Path {         let path = UIBezierPath(            roundedRect: rect,             byRoundingCorners: corners,   cornerRadii: CGSize(width: radius, height: radius)        );      return Path(path.cgPath)     } }
