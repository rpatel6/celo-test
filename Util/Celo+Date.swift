//
//  DateHelper.swift
//  Celo test
//
//  Created by Raj Patel on 18/04/20.
//  Copyright © 2020 Raj Patel. All rights reserved.
//

import Foundation
import UIKit

class DateHelper {
    static let shared = DateHelper()
    let formatter = DateFormatter()
}

extension Date {
    
    static let formatter = DateHelper.shared.formatter
    
    static func convertToDate(from string: String) -> Date? {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: string)
    }
    
    static func convertToString(from date: Date) -> String? {
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    static func convertToPrettyString(from dateString: String) -> String? {
        guard let date = convertToDate(from: dateString) else {
            return nil
        }
        let prettyString = convertToString(from: date)
        return prettyString
    }
}
