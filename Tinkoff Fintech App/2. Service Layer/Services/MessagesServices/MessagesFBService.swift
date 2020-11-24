//
//  MessagesFBService.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 24.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation

protocol MessagesFBServiceProto: class {
    func getDataFromFB(channelsDB: [MessageDB], comletion: @escaping () -> Void)
    func sendMessage(content: String, senderId: String, senderName: String, completion: @escaping () -> Void)
}

class MessagesFBService: MessagesFBServiceProto {
    
    private let messagesFBManager: MessagesFBManager
    private let storageManager: StorageManager
    
    func getDataFromFB(channelsDB: [MessageDB], comletion: @escaping () -> Void) {
        messagesFBManager.getMessages { [weak self] (addedMessagesFB) in
            self?.storageManager.coreDataStack.performSave { (context) in
                
                for messageFB in addedMessagesFB {
                    if channelsDB.contains(where: { $0.identifierMessage == messageFB.identifierMessage }) {
                        continue
                    } else {
                        _ = messageFB.makeMessageDBModel(context: context)
                    }
                }
            }
            comletion()
        }
    }
    
    func sendMessage(content: String, senderId: String, senderName: String, completion: @escaping () -> Void) {
        messagesFBManager.sendMessage(content: content, senderId: senderId, senderName: senderName, completion: completion)
    }
    
    init(messagesFBManager: MessagesFBManager, storageManager: StorageManager) {
        self.messagesFBManager = messagesFBManager
        self.storageManager = storageManager
    }
}
