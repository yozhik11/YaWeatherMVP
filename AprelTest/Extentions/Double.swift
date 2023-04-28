//
//  String.swift
//  AprelTest
//
//  Created by Natalia Shevaldina on 27.04.2023.
//

import Foundation

extension Double {
    // Пробразование даты из Unixtime к формату DateFormat
    func dateStringFromUnixtime(format: DateFormat) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: date)
    }
}
