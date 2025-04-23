//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by Артем Солодовников on 21.04.2025.
//

import Foundation

final class TrackerViewModel {
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    func numberOfSections(for date: Date) -> Int {
        visibleCategories(for: date).count
    }
    
    func numberOfItems(in section: Int, for date: Date) -> Int {
        visibleCategories(for: date)[section].trackers.count
    }
    
    func tracker(at indexPath: IndexPath, for date: Date) -> Tracker {
        visibleCategories(for: date)[indexPath.section].trackers[indexPath.item]
    }
    
    func sectionTitle(for section: Int, date: Date) -> String {
        visibleCategories(for: date)[section].name
    }
    
    func totalVisibleTrackers(for date: Date) -> Int {
        visibleCategories(for: date).reduce(0) { $0 + $1.trackers.count }
    }
    
    func toggleTrackerCompletion(trackerID: UUID, on date: Date) {
        let dayStart = Calendar.current.startOfDay(for: date)
        let record = TrackerRecord(trackerId: trackerID, date: dayStart)
        
        if let index = completedTrackers.firstIndex(of: record) {
            completedTrackers.remove(at: index)
        } else {
            completedTrackers.append(record)
        }
    }
    
    func completedDays(for trackerID: UUID) -> Int {
        completedTrackers.filter { $0.trackerId == trackerID }.count
    }
    
    func isTrackerCompleted(_ trackerID: UUID, on date: Date) -> Bool {
        completedTrackers.contains { $0.trackerId == trackerID && Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func shouldDisplay(_ tracker: Tracker, on date: Date) -> Bool {
        if tracker.schedule.isEmpty {
            return isTrackerCompleted(tracker.id, on: date)
            || !completedTrackers.contains(where: { $0.trackerId == tracker.id })
        }
        
        let systemWeekday = Calendar.current.component(.weekday, from: date)
        guard let weekday = DayOfWeek.fromSystemWeekday(systemWeekday) else { return false }
        
        return tracker.schedule.contains(weekday)
    }
    
    func visibleCategories(for date: Date) -> [TrackerCategory] {
        categories.compactMap { category in
            let trackers = category.trackers.filter { shouldDisplay($0, on: date) }
            return trackers.isEmpty ? nil : TrackerCategory(name: category.name, trackers: trackers)
        }
    }
    
    func addTracker(_ tracker: Tracker, toCategoryWithTitle title: String) {
        if let index = categories.firstIndex(where: { $0.name == title }) {
            let updated = TrackerCategory(name: title, trackers: categories[index].trackers + [tracker])
            categories[index] = updated
        } else {
            let new = TrackerCategory(name: title, trackers: [tracker])
            categories.append(new)
        }
    }
}
