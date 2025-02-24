//
//  CommonDetailView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 2/24/25.
//

import SwiftUI
import SwiftData

struct CommonDetailView<Item: CollectibleItem, Content: View>: View {
    @Binding var item: Item
    let additionalContent: Content
    @State private var showingDonationHistory = false
    
    init(item: Binding<Item>, @ViewBuilder additionalContent: () -> Content) {
        self._item = item
        self.additionalContent = additionalContent()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Item-specific content passed in
                additionalContent
                
                // Donation date picker
                DonationDatePickerView(item: $item)
                
                // More info
                DetailMoreInfoView(item: item)
                
                // View donation history button
                Button(action: {
                    showingDonationHistory = true
                }) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                        Text("View Donation History")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(Color.accentColor.opacity(0.1))
                    .foregroundColor(.accentColor)
                    .cornerRadius(12)
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(item.name)
        .sheet(isPresented: $showingDonationHistory) {
            NavigationStack {
                if let modelContext = item.modelContext {
                    DonationHistoryView(modelContext: modelContext)
                } else {
                    Text("Unable to access model context")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

// MARK: - Extensions for accessing ModelContext

extension CollectibleItem {
    var modelContext: ModelContext? {
        // Try to get the ModelContext from the object
        // This assumes the item is a ModelObject (from SwiftData)
		guard let modelObject = (Mirror(reflecting: self).descendant("_$observationRegistrar")? as AnyObject).descendant("context") else {
            return nil
        }
        return modelObject as? ModelContext
    }
}

// MARK: - Preview
struct CommonDetailView_Previews: PreviewProvider {
    static var previewFossil = Fossil(name: "Test Fossil", isDonated: true, games: [.ACGCN])
    
    static var previews: some View {
        NavigationStack {
            CommonDetailView(item: .constant(previewFossil)) {
                Text("Fossil-specific content would go here")
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
}
