//
//  TimeStampFormatter.swift
//  Ripple
//
//  Created by Abhishek Velekar on 21/12/25.
//
import Foundation

func formatTimestamp(timestamp: Int64) -> String {
    let calendar = Calendar.current
    let now = Date().timeIntervalSince1970 * 1000
    let today = calendar.component(.dayOfYear, from: Date())
    let yesterday = today - 1

    let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
    let dayOfYear = calendar.component(.dayOfYear, from: date)
    let year = calendar.component(.year, from: date)
    let currentYear = calendar.component(.year, from: Date())

    let dateFormatter = DateFormatter()

    switch (dayOfYear, year) {
    case (today, _):
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    case (yesterday, currentYear):
        return "Yesterday"
    default:
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }
}
