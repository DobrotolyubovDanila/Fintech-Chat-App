//
//  StorageService.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 20.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation
import CoreData

protocol StorageServiceProto: class {
    var storageManager: StorageManager { get }
}

class StorageService: StorageServiceProto {
    
    let storageManager: StorageManager
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
}
