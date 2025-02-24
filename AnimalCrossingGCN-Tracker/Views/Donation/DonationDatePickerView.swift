//
//  DonationDatePickerView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 2/24/25.
//

import SwiftUI

struct DonationDatePickerView<Item: CollectibleItem>: View {
    @Binding var item: Item
    @State private var isShowingDatePicker = false
    @State private var selectedDate: Date
    
    init(item: Binding<Item>) {
        self._item = item
        self._selectedDate = State(initialValue: item.wrappedValue.donationDate ?? Date())
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Donation status toggle
            Toggle("Donated to Museum", isOn: Binding(
                get: { item.isDonated },
                set: { newValue in
                    if newValue {
                        item.isDonated = true
                        if item.donationDate == nil {
                            // Only set to current date if not already set
                            item.donationDate = Date()
                            selectedDate = Date()
                        }
                    } else {
                        item.isDonated = false
                        // Leave donationDate as is unless explicitly cleared
                    }
                }
            ))
            .padding(.vertical, 4)
            
            if item.isDonated {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Donation Date")
                            .font(.subheadline)
                        Spacer()
                        Button(action: {
                            item.donationDate = nil
                        }) {
                            Text("Clear")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isShowingDatePicker.toggle()
                        }
                    }) {
                        HStack {
                            if let date = item.donationDate {
                                Text(date.formatted(date: .long, time: .omitted))
                                    .foregroundColor(.primary)
                            } else {
                                Text("Select a date")
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "calendar")
                                .foregroundColor(.accentColor)
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    if isShowingDatePicker {
                        VStack {
                            DatePicker(
                                "Donation Date",
                                selection: $selectedDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.graphical)
                            .onChange(of: selectedDate) { oldValue, newValue in
                                item.donationDate = newValue
                            }
                            
                            HStack {
                                Button(action: {
                                    // Set to today
                                    selectedDate = Date()
                                    item.donationDate = Date()
                                }) {
                                    Text("Today")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        isShowingDatePicker = false
                                    }
                                }) {
                                    Text("Done")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                            .padding(.top, 8)
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.05))
                        .cornerRadius(12)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    if let donationDate = item.donationDate {
                        Text("Donated \(getRelativeTimeDescription(from: donationDate))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                            .padding(.leading, 4)
                    }
                }
            }
        }
        .animation(.easeInOut, value: item.isDonated)
        .padding()
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(12)
    }
    
    // Helper function to generate relative time descriptions
    private func getRelativeTimeDescription(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Preview
struct DonationDatePickerView_Previews: PreviewProvider {
    static var previewFossil = Fossil(name: "Test Fossil", isDonated: true, games: [.ACGCN])
    
    static var previews: some View {
        VStack {
            DonationDatePickerView(item: .constant(previewFossil))
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
