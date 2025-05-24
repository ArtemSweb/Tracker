//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Артем Солодовников on 02.05.2025.
//

import CoreData

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    
    var onCategoriesChanged: (([TrackerCategoryCoreData]) -> Void)?

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func notifyObservers() {
        let all = fetchAllCategories()
        onCategoriesChanged?(all)
    }

    func fetchCategory(with title: String) -> TrackerCategoryCoreData? {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)

        return try? context.fetch(request).first
    }
    
    func createCategoryIfNeeded(title: String) -> TrackerCategoryCoreData {
        if let existing = fetchCategory(with: title) {
            return existing
        }
        
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.title = title
        saveContext()
        return newCategory
    }

    func fetchAllCategories() -> [TrackerCategoryCoreData] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения контекста категории: \(error)")
        }
    }
    
    func renameCategory(_ category: TrackerCategoryCoreData, to newTitle: String) {
        category.title = newTitle
        saveContext()
        notifyObservers()
    }
    
    func deleteCategory(_ category: TrackerCategoryCoreData) {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", category)

        do {
            let trackers = try context.fetch(request)
            trackers.forEach { context.delete($0) }
        } catch {
            print("Ошибка при получении трекеров для удаления категории: \(error)")
        }

        context.delete(category)
        saveContext()
        notifyObservers()
    }
}
