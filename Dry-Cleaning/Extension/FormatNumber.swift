//
//  FromatNumber.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import Foundation

extension String {
    func formatNumber() -> String? {
        // Remove existing formatting
        var rawNumber = self.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        rawNumber = rawNumber.replacingOccurrences(of: ",", with: ".")

        // Separate the integer and fractional parts
        let components = rawNumber.components(separatedBy: ".")

        guard let integerPart = components.first else {
            return nil
        }

        // Format integer part
        var formattedInteger = ""
        for (index, digit) in integerPart.reversed().enumerated() {
            if index != 0 && index % 3 == 0 {
                formattedInteger = " " + formattedInteger
            }
            formattedInteger = String(digit) + formattedInteger
        }

        // Append fractional part if it exists
        if components.count > 1, let fractionalPart = components.last {
            formattedInteger += "." + fractionalPart
        }

        return formattedInteger
    }
    
    func isValidNumberFormat(_ maxDigits: Int = 8) -> Bool {
        let regex = "^(\\d{0,\(maxDigits)})(\\.\\d{0,\(2)})?$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        let withoutProb = self.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        return predicate.evaluate(with: withoutProb)
    }
}
