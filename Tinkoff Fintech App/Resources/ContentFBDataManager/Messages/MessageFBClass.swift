//
//  MessageClass.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 21.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class MessageFB {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    var identifierMessage: String
    var identifierChannel: String
    
    init(content: String, created: Date, senderId: String, senderName: String, identifierMessage: String, identifierChannel: String) {
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
        self.identifierMessage = identifierMessage
        self.identifierChannel = identifierChannel
    }
    
    init? (decodeWith dict: [String: Any], identifierMessage: String, identifierChannel: String) {
        guard let content = dict["content"] as? String,
              let created = (dict["created"] as? Timestamp)?.dateValue(),
              let senderId = dict["senderId"] as? String,
              let senderName = dict["senderName"] as? String else { return nil }
        
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
        self.identifierMessage = identifierMessage
        self.identifierChannel = identifierChannel
    }
    
    func encode() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["content"] = self.content
        dict["created"] = Timestamp(date: self.created)
        dict["senderId"] = self.senderId
        dict["senderName"] = self.senderName
        
        return dict
    }
    
    func makeMessageDBModel(context: NSManagedObjectContext) -> MessageDB {
        let messageDB = MessageDB(content: self.content,
                                  created: self.created,
                                  senderId: self.senderId,
                                  senderName: self.senderName,
                                  identifierChannel: self.identifierChannel,
                                  identifierMessage: self.identifierMessage,
                                  context: context)
        return messageDB
    }
}
