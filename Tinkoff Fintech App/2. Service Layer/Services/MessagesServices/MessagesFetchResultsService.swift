//
//  MessagesFetchResultsService.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 24.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit
import CoreData

protocol MessagesFetchedResultsServiceProto: class {
    var fetchedResultsController: NSFetchedResultsController<MessageDB> { get }
    
    func setupFetchResultsController(tableView: UITableView)
}

class MessagesFetchResultsService: NSObject, MessagesFetchedResultsServiceProto {
    
    private let identifierChannel: String
    
    private let mainContext: NSManagedObjectContext
    
    private var tableView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<MessageDB> = {
        let request: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        request.predicate = NSPredicate(format: "identifierChannel = %@", self.identifierChannel)
        request.sortDescriptors = [sortDescriptor]
        request.resultType = .managedObjectResultType
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: mainContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    init(identifierChannel: String, mainContext: NSManagedObjectContext) {
        self.identifierChannel = identifierChannel
        self.mainContext = mainContext
    }
    
    func setupFetchResultsController(tableView: UITableView) {
        self.tableView = tableView
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error performFetch. ", error.localizedDescription)
        }
    }
}

extension MessagesFetchResultsService: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.beginUpdates()
        }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            print("default message case")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.endUpdates()
        }
}
