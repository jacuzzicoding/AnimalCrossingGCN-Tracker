import Foundation //foundation is needed for Date, it is a built in library in swift

protocol DonationTimestampable {
	// Required properties that conforming types must implement
	var isDonated: Bool { get set }
	var donationDate: Date? { get set }
}

// Default implementations for all DonationTimestampable types
extension DonationTimestampable {
	// Donation management
	mutating func markDonated() {
		isDonated = true
		donationDate = Date()
		print("Donation date set to: \(donationDate?.description ?? "nil")")
	}
	
	mutating func unmarkDonated() {
		isDonated = false
		donationDate = nil
	}
	
	// Formatted date access
	var formattedDonationDate: String? {
		guard let donationDate else { return nil }
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		return formatter.string(from: donationDate)
	}
	
	// Donation analytics helpers
	var donationMonth: Int? {
		guard let donationDate else { return nil }
		return Calendar.current.component(.month, from: donationDate)
	}
	
	var donationYear: Int? {
		guard let donationDate else { return nil }
		return Calendar.current.component(.year, from: donationDate)
	}
	
	// Logging functionality
	func logDonation() {
		guard let donationDate else { return }
		let logMessage = "Donation made on: \(donationDate)"
		appendToLogFile(message: logMessage)
	}
	
	private func appendToLogFile(message: String) {
		let fileManager = FileManager.default
		guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
			print("Could not find documents directory")
			return
		}
		
		let logFileURL = documentsDirectory.appendingPathComponent("donation_log.txt")
		
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
