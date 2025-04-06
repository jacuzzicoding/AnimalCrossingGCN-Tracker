import SwiftUI
import UniformTypeIdentifiers
import SwiftData

struct ExportOptionsView: View {
    let analyticsData: AnalyticsExportData
    let onExport: (URL) -> Void // Callback with the exported file URL

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataManager: DataManager // Access DataManager for exportService

    @State private var exportFormat: ExportFormat = .csv
    @State private var exportName: String = "Animal_Crossing_Analytics" // Default filename
    @State private var isExporting = false
    @State private var exportError: String?

    var body: some View {
        // Use NavigationView for title and cancel button, common on sheets
        NavigationView {
            Form {
                Section(header: Text("Export Format")) {
                    // Use Picker for format selection
                    Picker("Format", selection: $exportFormat) {
                        Text("CSV File (.csv)").tag(ExportFormat.csv)
                        Text("PNG Image (.png)").tag(ExportFormat.png).disabled(true) // Disable unimplemented
                        Text("PDF Document (.pdf)").tag(ExportFormat.pdf).disabled(true) // Disable unimplemented
                    }
                    .pickerStyle(SegmentedPickerStyle()) // Use segmented style for few options
                }

                Section(header: Text("File Name (Optional)")) {
                    // TextField for custom file name
                    TextField("Enter filename (no extension)", text: $exportName)
                        // Basic sanitization, replace spaces with underscores
                        .onChange(of: exportName) { _, newValue in
                             exportName = newValue.replacingOccurrences(of: " ", with: "_")
                        }
                }

                // Display error message if export fails
                if let error = exportError {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }

                // Export button section
                Section {
                    Button(action: performExport) {
                        HStack {
                            Spacer()
                            if isExporting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            } else {
                                Text("Export Data")
                            }
                            Spacer()
                        }
                    }
                    .disabled(isExporting || exportName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) // Disable if exporting or name is empty
                }
            }
            .navigationTitle("Export Options")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline) // Use inline title for sheets only on iOS
            #endif
            .toolbar {
                // Cancel button in the toolbar
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss() // Dismiss the sheet
                    }
                }
            }
        }
        // On macOS, sheets might need a frame
        #if os(macOS)
        .frame(minWidth: 350, idealWidth: 400, minHeight: 300)
        #endif
    }

    /// Performs the export operation based on selected format and name
    private func performExport() {
        guard !exportName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            exportError = "Please enter a valid file name."
            return
        }

        isExporting = true
        exportError = nil

        // Use DispatchQueue to avoid blocking the main thread, especially if PNG/PDF were complex
        DispatchQueue.global(qos: .userInitiated).async {
            var resultURL: URL?
            var errorString: String?

            switch exportFormat {
            case .csv:
                // Call the export service method
                resultURL = dataManager.exportService.exportToCSV(data: analyticsData, fileName: exportName)
                if resultURL == nil {
                    errorString = "Failed to export CSV data. Check console for details."
                }
            case .png, .pdf:
                // Handle unimplemented formats
                 errorString = "\(exportFormat) export is not yet implemented."
             case .clipboard: // Added clipboard case
                 errorString = "Clipboard export is not yet implemented."
            }

            // Update UI back on the main thread
            DispatchQueue.main.async {
                isExporting = false
                if let url = resultURL {
                    print("Export successful: \(url)")
                    onExport(url) // Call the success callback
                } else {
                    exportError = errorString ?? "An unknown export error occurred."
                    print("Export failed: \(exportError ?? "Unknown error")")
                }
            }
        }
    }
}

// Preview Provider
struct ExportOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        // Create dummy data for preview
        let previewData = AnalyticsExportData(donationActivity: nil, categoryCompletion: nil, seasonalData: nil)

        // Create in-memory DataManager for preview
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Town.self, configurations: config)
        let dataManager = DataManager(modelContext: container.mainContext)

        ExportOptionsView(
            analyticsData: previewData,
            onExport: { url in print("Preview Exported to: \(url)") }
        )
        .environmentObject(dataManager)
    }
}
