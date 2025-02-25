//
//  DonationDatePickerView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 2/24/25.
//

import SwiftUI
import SwiftData

struct DonationDatePickerView<Item: CollectibleItem>: View {
    var item: Item
    @State private var isShowingDatePicker = false
    @State private var selectedDate: Date
    @State private var isDonated: Bool
    
    init(item: Item) {
        self.item = item
        self._selectedDate = State(initialValue: item.donationDate ?? Date())
        self._isDonated = State(initialValue: item.isDonated)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Donation status toggle
            Toggle("Donated to Museum", isOn: Binding(
                get: { isDonated },
                set: { newValue in
                    isDonated = newValue
                    
                    // Update the actual model
                    if let model = item as? Fossil {
                        if newValue {
                            model.isDonated = true
                            if model.donationDate == nil {
                                model.donationDate = Date()
                                selectedDate = Date()
                            }
                        } else {
                            model.isDonated = false
                        }
                    } else if let model = item as? Bug {
                        if newValue {
                            model.isDonated = true
                            if model.donationDate == nil {
                                model.donationDate = Date()
                                selectedDate = Date()
                            }
                        } else {
                            model.isDonated = false
                        }
                    } else if let model = item as? Fish {
                        if newValue {
                            model.isDonated = true
                            if model.donationDate == nil {
                                model.donationDate = Date()
                                selectedDate = Date()
                            }
                        } else {
                            model.isDonated = false
                        }
                    } else if let model = item as? Art {
                        if newValue {
                            model.isDonated = true
                            if model.donationDate == nil {
                                model.donationDate = Date()
                                selectedDate = Date()
                            }
                        } else {
                            model.isDonated = false
                        }
                    }
                }
            ))
            .padding(.vertical, 4)
            
            if isDonated {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Donation Date")
                            .font(.subheadline)
                        Spacer()
                        Button(action: {
                            // Clear the donation date
                            if let model = item as? Fossil {
                                model.donationDate = nil
                            } else if let model = item as? Bug {
                                model.donationDate = nil
                            } else if let model = item as? Fish {
                                model.donationDate = nil
                            } else if let model = item as? Art {
                                model.donationDate = nil
                            }
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
                            if let date = getCurrentDonationDate() {
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
                                // Update the model's donation date
                                if let model = item as? Fossil {
                                    model.donationDate = newValue
                                } else if let model = item as? Bug {
                                    model.donationDate = newValue
                                } else if let model = item as? Fish {
                                    model.donationDate = newValue
                                } else if let model = item as? Art {
                                    model.donationDate = newValue
                                }
                            }
                            
                            HStack {
                                Button(action: {
                                    // Set to today
                                    selectedDate = Date()
                                    
                                    // Update the model
                                    if let model = item as? Fossil {
                                        model.donationDate = Date()
                                    } else if let model = item as? Bug {
                                        model.donationDate = Date()
                                    } else if let model = item as? Fish {
                                        model.donationDate = Date()
                                    } else if let model = item as? Art {
                                        model.donationDate = Date()
                                    }
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
                    
                    if let donationDate = getCurrentDonationDate() {
                        Text("Donated \(getRelativeTimeDescription(from: donationDate))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                            .padding(.leading, 4)
                    }
                }
            }
        }
        .animation(.easeInOut, value: isDonated)
        .padding()
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(12)
    }
    
    // Helper function to get current donation date from the actual model
    private func getCurrentDonationDate() -> Date? {
        if let model = item as? Fossil {
            return model.donationDate
        } else if let model = item as? Bug {
            return model.donationDate
        } else if let model = item as? Fish {
            return model.donationDate
        } else if let model = item as? Art {
            return model.donationDate
        }
        return nil
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
            DonationDatePickerView(item: previewFossil)
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
