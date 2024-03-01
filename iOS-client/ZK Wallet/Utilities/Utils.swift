//
//  Utils.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 02/26/24.
//

import Foundation

func isValidPhoneNumber(_ number: String) -> Bool {
    return !number.isEmpty && number.count == 10 && number.allSatisfy { $0.isNumber }
}


func formatDate(_ dateString: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withColonSeparatorInTimeZone]

    if let date = isoFormatter.date(from: dateString) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    } else {
        return "Invalid Date"
    }
}
