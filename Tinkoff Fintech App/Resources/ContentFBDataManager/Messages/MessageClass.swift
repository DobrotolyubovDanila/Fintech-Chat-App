//
//  MessageClass.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 21.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation
import Firebase

class Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    var identifier: String?
    
    init(content: String, created: Date, senderId: String, senderName: String) {
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
    
    init? (decodeWith dict: [String: Any]) {
        guard let content = dict["content"] as? String,
              let created = (dict["created"] as? Timestamp)?.dateValue(),
              let senderId = dict["senderId"] as? String,
              let senderName = dict["senderName"] as? String else { return nil }
        
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
    
    func encode() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["content"] = self.content
        dict["created"] = Timestamp(date: self.created)
        dict["senderId"] = self.senderId
        dict["senderName"] = self.senderName
        
        return dict
    }
}
