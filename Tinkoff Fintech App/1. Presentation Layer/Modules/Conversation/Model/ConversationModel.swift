//
//  ConversationModel.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 23.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

protocol ConversationModelProto {
    
    var identifierChannel: String { get set }
    var profileName: String { get set }
    var isKeyboardThere: Bool { get set }
    var localKeyboardHeight: CGFloat { get set }
    var countOfScrolls: Int { get set }
    var udid: String { get }
    
    func setupMessagesFetchedResultController(tableView: UITableView)
    func getMessagesFromFB(completion: @escaping () -> Void)
    func fetchedObjects() -> [MessageDB]
}

class ConversationModel: ConversationModelProto {
    
    private var storageService: StorageServiceProto
    
    private var firebaseService: MessagesFBServiceProto
    
    private let messagesFetchedResultsService: MessagesFetchedResultsServiceProto
    
    var identifierChannel: String
    
    var profileName = ""
    
    var isKeyboardThere = false
    
    var localKeyboardHeight: CGFloat = 0
    
    var countOfScrolls = 0
    
    let udid: String

    init(identifierChannel: String,
         messagesFetchedResultsService: MessagesFetchedResultsServiceProto,
         firebaseService: MessagesFBServiceProto,
         storageService: StorageServiceProto ) {
        self.messagesFetchedResultsService = messagesFetchedResultsService
        self.storageService = storageService
        self.firebaseService = firebaseService
        self.identifierChannel = identifierChannel
        self.udid = UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    func setupMessagesFetchedResultController(tableView: UITableView) {
        messagesFetchedResultsService.setupFetchResultsController(tableView: tableView)
    }
    
    func getMessagesFromFB(completion: @escaping () -> Void) {
        let fetchedObjects = messagesFetchedResultsService.fetchedResultsController.fetchedObjects ?? []
        firebaseService.getDataFromFB(channelsDB: fetchedObjects, comletion: completion)
    }
    
    func fetchedObjects() -> [MessageDB] {
        return messagesFetchedResultsService.fetchedResultsController.fetchedObjects ?? []
    }
}
