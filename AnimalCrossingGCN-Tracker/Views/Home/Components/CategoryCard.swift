import SwiftUI

struct CategoryCard: View {
    let title: String
    let icon: String
    let progress: Double
    let color: Color
    let emoji: String
    let donationInfo: String?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 60, height: 60)
                    VStack(spacing: 4) {
                        Text("\(Int(progress * 100))%")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        if let info = donationInfo {
                            Text(info)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                }
                Spacer()
                Spacer()
                HStack {
                    Spacer()
                    HStack {
                        Text("View All")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(15)
                    Spacer()
                }
            }
            .padding()
            .frame(height: 130)
            .background(color)
            .cornerRadius(10)
            .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(title): \(Int(progress * 100))% complete")
        }
    }
}
