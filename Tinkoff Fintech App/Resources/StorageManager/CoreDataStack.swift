//
//  CDStack.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 28.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var didUpdateDataBase: ((CoreDataStack) -> Void)?
    
    private lazy var storeUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).last
        else {
            fatalError("document path not found")
        }
        return documentsUrl.appendingPathComponent("\(dataModelName).sqlite")
    }()
    
    private var dataModelName: String = "Chat"
    private let dataModelExtension = "momd"
    
    // MARK: - Init Stack
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modeURL = Bundle.main.url(forResource: self.dataModelName,
                                            withExtension: self.dataModelExtension)
        else {
            fatalError("model not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modeURL)
        else {
            fatalError("managedObjectModel could not be created")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.storeUrl,
                                               options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        return coordinator
    }()
    
    // MARK: - Contexts
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                do {
                    try performSave(in: context)
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) throws {
        try context.save()
        if let parent = context.parent { try performSave(in: parent) }
    }
    
    // MARK: - Init
    
    init(dataModelName: String) {
        self.dataModelName = dataModelName
        print("инит")
    }
    
    // MARK: - CoreData Observers
    
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        didUpdateDataBase?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
           inserts.count > 0 {
            print("Добавленно объектов: ", inserts.count)
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
           updates.count > 0 {
            print("Обновленно объектов: ", updates.count)
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
           deletes.count > 0 {
            print("Удалено объектов: ", deletes.count)
        }
    }
    
    // MARK: - Core Data Logs
    
    func printDatabaseProfileStatistice() {
        mainContext.perform {
            do {
                let countProf = try self.mainContext.count(for: ProfileInfoDB.fetchRequest())
                print("\(countProf) – число профилей")
                let profiles = try self.mainContext.fetch(ProfileInfoDB.fetchRequest()) as? [ProfileInfoDB] ?? []
                profiles.forEach { print($0.about) }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func printDatabaseChannelStatistice() {
        mainContext.perform {
            do {
                let countChannels = try self.mainContext.count(for: ChannelDB.fetchRequest())
                print(countChannels, " – число каналов")
                let channels = try self.mainContext.fetch(ChannelDB.fetchRequest()) as? [ChannelDB] ?? []
                channels.forEach { print($0.about) }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func printDatabaseMessagesStatistice() {
        mainContext.perform {
            do {
                let countMessages = try self.mainContext.count(for: MessageDB.fetchRequest())
                print(countMessages, " – число сообщений")
                let messages = try self.mainContext.fetch(MessageDB.fetchRequest()) as? [MessageDB] ?? []
                messages.forEach { print($0.about) }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
