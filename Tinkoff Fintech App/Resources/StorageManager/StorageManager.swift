//
//  StorageManager.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 29.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation
import CoreData

class StorageManager {
    var coreDataStack: CoreDataStack!
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func saveChannels(channels: [Channel]?) {
        guard let channels = channels else { return }
        coreDataStack.performSave { context in
            channels.forEach { channel in
                _ = ChannelDB(identifier: channel.identifier,
                          name: channel.name,
                          lastMessage: channel.lastMessage,
                          lastActivity: channel.lastActivity,
                          context: context)
            }
        }
    }
    
    func saveMessages(messages: [Message]?, identifierChannel: String?) {
        guard let messages = messages, let identifierChannel = identifierChannel else { return }
        
        coreDataStack.performSave { context in
            messages.forEach { message in
                _ = MessageDB(content: message.content,
                              created: message.created,
                              senderId: message.senderId,
                              senderName: message.senderName,
                              identifierChannel: identifierChannel,
                              context: context)
            }
        }
    }
}
