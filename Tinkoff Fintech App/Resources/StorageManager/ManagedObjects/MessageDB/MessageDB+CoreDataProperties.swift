//
//  MessageDB+CoreDataProperties.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 29.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//
//

import Foundation
import CoreData

extension MessageDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageDB> {
        return NSFetchRequest<MessageDB>(entityName: "MessageDB")
    }

    @NSManaged public var content: String
    @NSManaged public var created: Date
    @NSManaged public var senderId: String
    @NSManaged public var senderName: String
    @NSManaged public var identifierChannel: String
    @NSManaged public var identifierMessage: String
    
    convenience init(content: String, created: Date, senderId: String, senderName: String, identifierChannel: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
        self.identifierChannel = identifierChannel
    }
    
    var about: String {
        return "Отправитель – " + senderName + ", сообщение " + content
    }
}
