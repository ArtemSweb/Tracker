//
//  Filtres.swift
//  Tracker
//
//  Created by Артем Солодовников on 24.05.2025.
//

enum Filtres: Int, CaseIterable {
    case all
    case today
    case completed
    case uncompleted

    var title: String {
        switch self {
        case .all: return L10n.allTrackers
        case .today: return L10n.trackersToday
        case .completed: return L10n.completed
        case .uncompleted: return L10n.uncompleted
        }
    }
}
