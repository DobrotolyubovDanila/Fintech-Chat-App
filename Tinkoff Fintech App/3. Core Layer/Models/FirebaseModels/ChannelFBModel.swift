//
//  ChannelData.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 21.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class ChannelFB {
    var name: String
    var identifier: String
    var lastMessage: String?
    var lastActivity: Date?
    
    init? (decodeWith dict: [String: Any], identifier: String) {
        guard let name = dict["name"] as? String else { return nil }
        
        self.name = name
        self.identifier = identifier
        self.lastActivity = (dict["lastActivity"] as? Timestamp)?.dateValue()
        self.lastMessage = dict["lastMessage"] as? String
        
    }
    
    init(name: String, identifier: String, lastMessage: String?, lastActivity: Date?) {
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
        self.identifier = identifier
    }
    
    init(channelDB: ChannelDB) {
        self.name = channelDB.name
        self.identifier = channelDB.identifier
        self.lastMessage = channelDB.lastMessage
        self.lastActivity = channelDB.lastActivity
    }
    
    func makeChannelDBModel(context: NSManagedObjectContext) -> ChannelDB {
        let channelDB = ChannelDB(identifier: self.identifier,
                                  name: self.name,
                                  lastMessage: self.lastMessage,
                                  lastActivity: self.lastActivity,
                                  context: context)
        return channelDB
    }
    
    func encode() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["name"] = self.name
        dict["identifier"] = self.identifier
        dict["lastMessage"] = self.lastMessage
        dict["lastActivity"] = self.lastActivity ?? Date()
        
        return dict
    }
    
    static func makeArrayFromDB(channelDBArray: [ChannelDB]) -> [ChannelFB] {
        var channels: [ChannelFB] = []
        for item in channelDBArray {
            channels.append(ChannelFB(channelDB: item))
        }
        return channels
    }
}
