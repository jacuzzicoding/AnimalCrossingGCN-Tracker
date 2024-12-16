import SwiftUI

struct EditTownView: View {
    @Binding var isPresented: Bool
    @Binding var townName: String
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Town Details")) {
                    TextField("Town Name", text: $townName)
                }
            }
            .navigationTitle("Edit Town")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    dataManager.updateTownName(townName)
                    isPresented = false
                }
            )
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