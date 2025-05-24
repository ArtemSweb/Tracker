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
    var onTrackersUpdated: (([TrackerCategory]) -> Void)?
    var onStatisticUpdate: ((StatisticViewModel) -> Void)?
    let trackerStore: TrackerStore
    let categoryStore: TrackerCategoryStore
    let recordStore: TrackerRecordStore
    var currentFilter: Filtres = .all {
        didSet {
            onTrackersUpdated?(filteredCategories(for: selectedDate))
        }
    }
    
    var selectedDate: Date = Date()
    
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
        filteredCategories(for: date).count
    }
    
    func numberOfItems(in section: Int, for date: Date) -> Int {
        filteredCategories(for: date)[section].trackers.count
    }
    
    func tracker(at indexPath: IndexPath, for date: Date) -> Tracker {
        filteredCategories(for: date)[indexPath.section].trackers[indexPath.item]
    }
    
    func sectionTitle(for section: Int, date: Date) -> String {
        filteredCategories(for: date)[section].name
    }
    
    func totalVisibleTrackers(for date: Date) -> Int {
        filteredCategories(for: date).reduce(0) { $0 + $1.trackers.count }
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
        notifyStatisticUpdate()
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
        notifyStatisticUpdate()
    }
    
    func loadTrackers() {
        categories = trackerStore.fetchTrackersGroupedByCategory()
        onTrackersUpdated?(categories)
    }
    
    func updateTracker(_ tracker: Tracker, newCategory: TrackerCategoryCoreData?) {
        trackerStore.updateTracker(tracker, newCategory: newCategory)
        loadTrackers()
        notifyStatisticUpdate()
    }
    
    func deleteTracker(for tracker: Tracker) {
        trackerStore.deleteTracker(for: tracker.id)
        loadTrackers()
        notifyStatisticUpdate()
    }
    
    //Обновление статистики
    private func notifyStatisticUpdate() {
        let allTrackers = categories.flatMap { $0.trackers }
        let statVM = StatisticViewModel(trackers: allTrackers, records: completedTrackers)
        onStatisticUpdate?(statVM)
    }
    
    func togglePin(for tracker: Tracker) {
        trackerStore.updatePinState(for: tracker.id, isPinned: !tracker.isPinned)
        loadTrackers()
        notifyStatisticUpdate()
    }
    
    func filteredCategories(for date: Date) -> [TrackerCategory] {
        let categories = visibleCategories(for: date)
        switch currentFilter {
        case .all:
            return categories
        case .today:
            let today = Calendar.current.startOfDay(for: Date())
            if Calendar.current.isDate(date, inSameDayAs: today) {
                return categories
            } else {
                return []
            }
        case .completed:
            return categories.compactMap { category in
                let trackers = category.trackers.filter { isTrackerCompleted($0.id, on: date) }
                return trackers.isEmpty ? nil : TrackerCategory(name: category.name, trackers: trackers)
            }
        case .uncompleted:
            return categories.compactMap { category in
                let trackers = category.trackers.filter { !isTrackerCompleted($0.id, on: date) }
                return trackers.isEmpty ? nil : TrackerCategory(name: category.name, trackers: trackers)
            }
        }
    }
    
    func hasAnyTrackers(for date: Date) -> Bool {
        let categories = categories
        let count = categories.reduce(0) { $0 + $1.trackers.count }
        return count > 0
    }
}

extension TrackerViewModel: TrackerStoreDelegate {
    func didUpdateTrackers() {
        loadTrackers()
    }
}
