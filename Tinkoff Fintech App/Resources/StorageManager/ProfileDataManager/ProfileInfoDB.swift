//
//  ProfileInfo.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 29.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit
import CoreData

extension ProfileInfoDB {
    
    convenience init(name: String,
                     profileId: String,
                     imageData: Data?,
                     profileInformation: String?,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.profileId = profileId
        self.profileInformation = profileInformation
        self.profileImageData = imageData
    }
    
    convenience init?(profileInfo: ProfileInformation, context: NSManagedObjectContext) {
        guard let udid = UIDevice.current.identifierForVendor?.uuidString else { return nil }

        self.init(context: context)
        self.name = profileInfo.name
        self.profileId = udid
        self.profileInformation = profileInfo.description
        self.profileImageData = profileInfo.imageData
    }
    
    var about: String {
        var pName = "name: "
        if let name = name {
            pName += name
        } else {
            pName += "no name"
        }
        
        var pId = "id: "
        if let id = profileId {
            pId += id
        } else {
            pId += "no profileId"
        }
        
        return pName + ", " + pId
    }
}
