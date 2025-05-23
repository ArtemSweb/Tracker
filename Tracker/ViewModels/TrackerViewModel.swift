//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by Артем Солодовников on 21.04.2025.
//

import UIKit

final class TrackerViewModel {
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    let trackerStore: TrackerStore
    let categoryStore: TrackerCategoryStore
    let recordStore: TrackerRecordStore
    
    init(trackerStore: TrackerStore,
         categoryStore: TrackerCategoryStore,
         recordStore: TrackerRecordStore
    ) {
        self.trackerStore = trackerStore
        self.categoryStore = categoryStore
        self.recordStore = recordStore
        
        self.completedTrackers = recordStore.fetchAllRecords()
        trackerStore.delegate = self
    }
    
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
        let record = TrackerRecord(trackerId: trackerID, date: Calendar.current.startOfDay(for: date))
        
        if let index = completedTrackers.firstIndex(of: record) {
            recordStore.removeRecord(record)
            completedTrackers.remove(at: index)
        } else {
            recordStore.addRecord(record)
            completedTrackers.append(record)
        }
    }
    
    func completedDays(for trackerID: UUID) -> Int {
        recordStore.numberOfCompletions(trackerId: trackerID)
    }
    
    func isTrackerCompleted(_ trackerID: UUID, on date: Date) -> Bool {
        recordStore.isCompleted(trackerId: trackerID, on: date)
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
    
    func createTracker(
        name: String,
        emoji: String,
        color: UIColor,
        schedule: [DayOfWeek],
        categoryTitle: String,
        coreDataCategory: TrackerCategoryCoreData
    ) {
        let id = UUID()
        
        trackerStore.addTracker(
            id: id,
            name: name,
            emoji: emoji,
            color: color.convertToString(),
            schedule: schedule,
            category: coreDataCategory
        )
        loadTrackers()
    }
    
    func loadTrackers() {
        categories = trackerStore.fetchTrackersGroupedByCategory()
    }
}

extension TrackerViewModel: TrackerStoreDelegate {
    func didUpdateTrackers() {
        loadTrackers()
    }
}
