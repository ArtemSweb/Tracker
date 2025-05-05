//
//  DayOfWeek.swift
//  Tracker
//
//  Created by Артем Солодовников on 21.04.2025.
//

import Foundation

enum DayOfWeek: Int, CaseIterable, Codable {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

extension DayOfWeek {
    
    var fullDayName: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
    
    var shortDayName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
}

extension DayOfWeek {
    static func fromSystemWeekday(_ systemWeekday: Int) -> DayOfWeek? {
        let shift = (systemWeekday + 5) % 7 + 1
        return DayOfWeek(rawValue: shift)
    }
}
