//
//  ChannelData.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 21.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation
import Firebase

class ChannelData {
    var name: String
    var lastMessage: String?
    var lastActivity: Date
    
    required init? (decodeWith dict: [String:Any]) {
        guard let name = dict["name"] as? String,
              let lastActivity = dict["lastActivity"] as? Timestamp else { return nil }
        
        self.name = name
        self.lastActivity = lastActivity.dateValue()
        self.lastMessage = dict["lastMessage"] as? String
        
        if self.lastMessage == "" { self.lastMessage = nil }
    }
    
    init(name: String, lastMessage: String?, lastActivity: Date) {
        self.name = name
        self.lastMessage = lastMessage 
        self.lastActivity = lastActivity
    }
    
    func encode() -> [String:Any] {
        var dict: [String:Any] = [:]
        
        dict["name"] = self.name
        dict["lastMessage"] = self.lastMessage
        dict["lastActivity"] = Timestamp(date: self.lastActivity)
        
        return dict
    }
}
