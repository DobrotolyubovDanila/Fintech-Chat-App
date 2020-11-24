//
//  ChannelsFetchedResultsService.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 19.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit
import CoreData

protocol ChannelsFetchedResultsServiceProto: class {
    var fetchedResultsController: NSFetchedResultsController<ChannelDB> { get }
    
    func setupFetchResultsController(tableView: UITableView)
}

class ChannelsFetchedResultsService: NSObject, ChannelsFetchedResultsServiceProto {
    
    weak var tableView: UITableView!
    
    private var mainContext: NSManagedObjectContext
    
    lazy var fetchedResultsController: NSFetchedResultsController<ChannelDB> = {
        let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.resultType = .managedObjectResultType
        
        let fetchedResultsControlelr = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: mainContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsControlelr.delegate = self
        
        return fetchedResultsControlelr
    }()
    
    init(mainContext: NSManagedObjectContext) {
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
    
    deinit {
        print("Деинит фетч сервис")
    }
}

extension ChannelsFetchedResultsService: NSFetchedResultsControllerDelegate {
    
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
                print("обновили строку, ", indexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                print("удалили ряд ", indexPath)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                print("передвинули с ", indexPath, " до ", newIndexPath)
            }
        default:
            print("dafault channel case")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
