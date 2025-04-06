#if os(iOS)
import UIKit
import SwiftUI

/// UIActivityViewController wrapper for iOS share functionality
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Nothing to update
    }
}

#elseif os(macOS)
import AppKit
import SwiftUI

/// Simple sheet for sharing on macOS
struct ShareSheet: View {
    let items: [Any]

    var body: some View {
        VStack(spacing: 20) {
            Text("Share File")
                .font(.headline)
            
            if let url = items.first as? URL {
                Text(url.lastPathComponent)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button("Reveal in Finder") {
                    NSWorkspace.shared.activateFileViewerSelecting([url])
                }
                .buttonStyle(.bordered)
                
                Button("Copy Path") {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(url.path, forType: .string)
                }
                .buttonStyle(.bordered)
            } else {
                Text("No shareable content found")
                    .foregroundColor(.secondary)
            }
        }
        .padding(30)
        .frame(minWidth: 300, minHeight: 200)
    }
}
#endif
