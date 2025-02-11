import Foundation

class LoggingUtility {
    static let shared = LoggingUtility()
    private let logFileName = "donation_log.txt"
    
    private init() {}
    
    func logDonation(date: Date) {
        let logMessage = "Donation made on: \(date)"
        appendToLogFile(message: logMessage)
    }
    
    private func appendToLogFile(message: String) {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not find documents directory")
            return
        }
        
        let logFileURL = documentsDirectory.appendingPathComponent(logFileName)
        
        do {
            if !fileManager.fileExists(atPath: logFileURL.path) {
                try message.write(to: logFileURL, atomically: true, encoding: .utf8)
            } else {
                let fileHandle = try FileHandle(forWritingTo: logFileURL)
                fileHandle.seekToEndOfFile()
                if let data = ("\n" + message).data(using: .utf8) {
                    fileHandle.write(data)
                }
                fileHandle.closeFile()
            }
        } catch {
            print("Error writing to log file: \(error)")
        }
    }
}
