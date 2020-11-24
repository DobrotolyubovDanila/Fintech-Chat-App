//
//  ConversationsListModel.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 20.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit
import CoreData

protocol ConversationsListModelProtocol {
    func loadProfileInformation(completion: @escaping (ProfileInformation) -> Void)
    func setupFetchResultsController(tableView: UITableView)
    func getChannelsFromFB()
    func fetchedObjects() -> [ChannelDB]
    func addChannel(completion: (UIAlertController) -> Void)
    func deleteChannel(indexPath: IndexPath)
    var profileInformation: ProfileInformation? { get set }
}

class ConversationsListModel: ConversationsListModelProtocol {
    
    private var storageService: StorageServiceProto
    
    private var firebaseService: ChannelsFirebaseServiceProto
    
    private var channelsFetchedResultsService: ChannelsFetchedResultsServiceProto
    
    var profileInformation: ProfileInformation?
    
    init(storageService: StorageServiceProto, firebaseService: ChannelsFirebaseServiceProto, channelsFetchedResultsService: ChannelsFetchedResultsServiceProto) {
        
        self.storageService = storageService
        self.firebaseService = firebaseService
        self.channelsFetchedResultsService = channelsFetchedResultsService
    }
    
    func loadProfileInformation(completion: @escaping (ProfileInformation) -> Void) {
        storageService.storageManager.loadProfileInformation { profileInformation in
            completion(profileInformation)
        }
    }
    
    func setupFetchResultsController(tableView: UITableView) {
        channelsFetchedResultsService.setupFetchResultsController(tableView: tableView)
    }
    
    func getChannelsFromFB() {
        firebaseService.getDataFromFB(channelsDB: channelsFetchedResultsService.fetchedResultsController.fetchedObjects ?? [])
    }
    
    func fetchedObjects() -> [ChannelDB] {
        return channelsFetchedResultsService.fetchedResultsController.fetchedObjects ?? []
    }
    
    func addChannel(completion: (UIAlertController) -> Void) {
        let alert = UIAlertController(title: "Создать канал", message: "Введите название и сообщение", preferredStyle: .alert)
        
        alert.addTextField { (nameField) in
            nameField.autocapitalizationType = .sentences
            nameField.placeholder = "Название"
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Добавить", style: .default, handler: { [weak self] (_) in
            
            guard var name = alert.textFields?.first?.text, name != "" else { return }
            
            var check = false
            for char in name {
                if char != " " {
                    check = true
                    break
                } else {
                    name.removeFirst()
                }
            }
            guard check == true else { return }
            
            let channelFB = ChannelFB(name: name, identifier: "id", lastMessage: nil, lastActivity: nil)
            
            self?.firebaseService.addChannel(channel: channelFB)
        }))
        completion(alert)
    }
    
    func deleteChannel(indexPath: IndexPath) {
        let channel = fetchedObjects()[indexPath.row]
        let channelId = channel.identifier
        let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        request.predicate = NSPredicate(format: "identifier = %@", channelId)
        
        storageService.storageManager.coreDataStack.performSave { (context) in
            do {
                let channelDB = try context.fetch(request).first
                if let channelDB = channelDB {
                    context.delete(channelDB)
                    firebaseService.deleteChannel(channelId: channelId)
                }
            } catch {
                
            }
        }
    }
    
}
