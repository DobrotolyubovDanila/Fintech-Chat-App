//
//  FirebaseService.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 20.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol ChannelsFirebaseServiceProto: class {
    func getDataFromFB(channelsDB: [ChannelDB])
    func deleteChannel(channelId: String)
    func addChannel(channel: ChannelFB)
}

class ChannelsFirebaseService: ChannelsFirebaseServiceProto {
    
    private let channelsFBManager: ChannelsFBManager
    private let storageManager: StorageManager
    
    init(channelsFBManager: ChannelsFBManager, storageManager: StorageManager) {
        self.channelsFBManager = channelsFBManager
        self.storageManager = storageManager
    }
    
    func getDataFromFB(channelsDB: [ChannelDB]) {
        channelsFBManager.getChannelsFromFB { [weak self] (addedChannels, modifiedChannels, deletedChannelsIDs) in
            
            self?.storageManager.coreDataStack.performSave { (context) in
                for channelFB in addedChannels {
                    if channelsDB.contains(where: { $0.identifier == channelFB.identifier }) {
                        continue
                    } else {
                        _ = channelFB.makeChannelDBModel(context: context)
                    }
                }
                
                for channelFB in modifiedChannels {
                    let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                    request.predicate = NSPredicate(format: "identifier = %@", channelFB.identifier)
                    
                    do {
                        let channelDB = try context.fetch(request).first
                        if let channelDB = channelDB {
                            channelDB.name = channelFB.name
                            channelDB.lastMessage = channelFB.lastMessage
                            channelDB.lastActivity = channelFB.lastActivity
                        }
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
                
                for channelId in deletedChannelsIDs {
                    let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                    request.predicate = NSPredicate(format: "identifier = %@", channelId)
                    
                    do {
                        let channelDB = try context.fetch(request).first
                        if let channelDB = channelDB {
                            context.delete(channelDB)
                        }
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func deleteChannel(channelId: String) {
        channelsFBManager.deleteChannel(channelId: channelId)
    }
    
    func addChannel(channel: ChannelFB) {
        channelsFBManager.addChannel(channel: channel)
    }
}
