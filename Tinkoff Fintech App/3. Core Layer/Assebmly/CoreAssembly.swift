//
//  CoreAssembly.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 19.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation

protocol CoreAssemblyProto {
    
    var storageManager: StorageManager { get }
    
    var channelsFBManager: ChannelsFBManager { get }
    
    func messagesFBManager(idChannel: String) -> MessagesFBManager
}

class CoreAssembly: CoreAssemblyProto {
    
    lazy var storageManager: StorageManager = StorageManager(coreDataStack: CoreDataStack(dataModelName: "Chat"))
    
    lazy var channelsFBManager: ChannelsFBManager = ChannelsFBManager()
    
    func messagesFBManager(idChannel: String) -> MessagesFBManager {
        return MessagesFBManager(idChannel: idChannel)
    }
    
}
