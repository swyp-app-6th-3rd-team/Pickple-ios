//
//  Date+Relative.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//
import Foundation

extension Date {
    var relativeTimeDescription: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
