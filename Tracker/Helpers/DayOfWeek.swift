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
        case .monday: return L10n.mondayFull
        case .tuesday: return L10n.tuesdayFull
        case .wednesday: return L10n.wednesdayFull
        case .thursday: return L10n.thursdayFull
        case .friday: return L10n.fridayFull
        case .saturday: return L10n.saturdayFull
        case .sunday: return L10n.sundayFull
        }
    }
    
    var shortDayName: String {
        switch self {
        case .monday: return L10n.mondayShort
        case .tuesday: return L10n.tuesdayShort
        case .wednesday: return L10n.wednesdayShort
        case .thursday: return L10n.thursdayShort
        case .friday: return L10n.fridayShort
        case .saturday: return L10n.saturdayShort
        case .sunday: return L10n.sundayShort
        }
    }
}

extension DayOfWeek {
    static func fromSystemWeekday(_ systemWeekday: Int) -> DayOfWeek? {
        let shift = (systemWeekday + 5) % 7 + 1
        return DayOfWeek(rawValue: shift)
    }
}
