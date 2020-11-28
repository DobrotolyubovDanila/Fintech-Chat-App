//
//  ServicesAssebmly.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 19.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit
import CoreData

protocol ServicesAssemblyProto {
    
    var storageService: StorageServiceProto { get }
    
    var channelFBService: ChannelsFirebaseServiceProto { get }
    
    var networkImagesManager: NetworkImagesManager { get }
    
    func channelsFetchedResultsService() -> ChannelsFetchedResultsServiceProto
    
    func messagesFetchedResultsService(identifierChannel: String) -> MessagesFetchedResultsServiceProto
    
    func messagesFBService(idChannel: String) -> MessagesFBServiceProto
}

class ServicesAssembly: ServicesAssemblyProto {
    
    private var coreAssebmly: CoreAssemblyProto
    
    lazy var storageService: StorageServiceProto = {
        return StorageService(storageManager: coreAssebmly.storageManager)
    }()
    
    lazy var channelFBService: ChannelsFirebaseServiceProto = {
        let firebaseService = ChannelsFirebaseService(channelsFBManager: coreAssebmly.channelsFBManager,
                                              storageManager: storageService.storageManager)
        
        return firebaseService
    }()
    
    lazy var networkImagesManager: NetworkImagesManager = {
        return coreAssebmly.networkManager
    }()
    
    init(coreAssebmly: CoreAssemblyProto) {
        self.coreAssebmly = coreAssebmly
    }

    func channelsFetchedResultsService() -> ChannelsFetchedResultsServiceProto {
        let channelsFetchedResultsService: ChannelsFetchedResultsServiceProto = ChannelsFetchedResultsService(mainContext: coreAssebmly.storageManager.coreDataStack.mainContext)
        
        return channelsFetchedResultsService
    }
    
    func messagesFetchedResultsService(identifierChannel: String) -> MessagesFetchedResultsServiceProto {
        let mainContext = coreAssebmly.storageManager.coreDataStack.mainContext
        
        let messagesFetchedResultsService = MessagesFetchResultsService(identifierChannel: identifierChannel,
                                                                        mainContext: mainContext)
        
        return messagesFetchedResultsService
    }
    
    func messagesFBService(idChannel: String) -> MessagesFBServiceProto {
        let messagesFBService = MessagesFBService(messagesFBManager: coreAssebmly.messagesFBManager(idChannel: idChannel),
                                                  storageManager: coreAssebmly.storageManager)
        return messagesFBService
    }
}
