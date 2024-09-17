//
//  DateFormatter.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import Foundation

extension Date {
    func timeFormat() -> String {
        let timeFormmater = DateFormatter()
        timeFormmater.locale = Locale.current
        timeFormmater.dateFormat = "HH:mm"
        let formatedDate = timeFormmater.string(from: self)
        return formatedDate
    }
    
    func dateFormat() -> String {
        let dateFormmater = DateFormatter()
        dateFormmater.locale = Locale.current
        dateFormmater.dateFormat = "dd.MM.YYYY"
        let formatedDate = dateFormmater.string(from: self)
        return formatedDate
    }
}
