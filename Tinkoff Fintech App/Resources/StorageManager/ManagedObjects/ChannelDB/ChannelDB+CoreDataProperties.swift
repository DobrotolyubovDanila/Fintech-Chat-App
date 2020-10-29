//
//  ChannelDB+CoreDataProperties.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 29.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//
//

import Foundation
import CoreData

extension ChannelDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChannelDB> {
        return NSFetchRequest<ChannelDB>(entityName: "ChannelDB")
    }

    @NSManaged public var identifier: String
    @NSManaged public var name: String
    @NSManaged public var lastMessage: String?
    @NSManaged public var lastActivity: Date?
    
    convenience init (identifier: String, name: String, lastMessage: String?, lastActivity: Date?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
    
    var about: String {
        return "name: " + name + ", identifier: " + identifier
    }
}
