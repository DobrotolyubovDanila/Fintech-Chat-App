//
//  ChannelData.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 21.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation
import Firebase

class Channel {
    var name: String
    var identifier: String
    var lastMessage: String?
    var lastActivity: Date?
    
    init? (decodeWith dict: [String: Any], identifier: String) {
        guard let name = dict["name"] as? String,
              let lastActivity = (dict["lastActivity"] as? Timestamp)?.dateValue() else { return nil }
        
        self.name = name
        self.identifier = identifier
        self.lastActivity = lastActivity
        self.lastMessage = dict["lastMessage"] as? String
        
    }
    
    init(name: String, identifier: String, lastMessage: String?, lastActivity: Date?) {
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
        self.identifier = identifier
    }
    
    func encode() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["name"] = self.name
        dict["identifier"] = self.identifier
        dict["lastMessage"] = self.lastMessage
        dict["lastActivity"] = self.lastActivity ?? Date()
        
        return dict
    }
}
