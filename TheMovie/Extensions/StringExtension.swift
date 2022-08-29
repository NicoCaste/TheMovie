//
//  StringExtension.swift
//  TheMovie
//
//  Created by nicolas castello on 27/08/2022.
//

import Foundation

extension String {
    
    enum FormatDateType: String {
        case year = "yyyy"
        case month = "MM"
        case day = "dd"
        case yearMonth = "yyyy-MM"
        case yearMothDay = "yyyy-MM-dd"
    }
    
    func getDateFormatString(format: FormatDateType ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else { return self }
        dateFormatter.dateFormat = format.rawValue
        let stringDateFormat = dateFormatter.string(from: date)
        return stringDateFormat
    }
}
