import SwiftUI
import SwiftData

struct EditTownView: View {
    @Binding var isPresented: Bool
    @Binding var townName: String
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        #if os(macOS)
        editTownContent
            .frame(width: 300, height: 150)
        #else
        NavigationStack {
            editTownContent
                .navigationTitle("Edit Town")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isPresented = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            dataManager.updateTownName(townName)
                            isPresented = false
                        }
                    }
                }
        }
        #endif
    }
    
    private var editTownContent: some View {
        Form {
            Section(header: Text("Town Details")) {
                TextField("Town Name", text: $townName)
            }
            #if os(macOS)
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                Spacer()
                Button("Save") {
                    dataManager.updateTownName(townName)
                    isPresented = false
                }
            }
            .padding()
            #endif
        }
    }
}

#Preview {
    EditTownView(
        isPresented: .constant(true),
        townName: .constant("Test Town")
    )
    .environmentObject(DataManager(modelContext: try! ModelContext(ModelContainer(for: Town.self))))
}
