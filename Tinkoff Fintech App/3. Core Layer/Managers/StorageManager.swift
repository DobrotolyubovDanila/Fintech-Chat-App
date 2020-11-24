//
//  StorageManager.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 29.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation
import CoreData

class StorageManager {
    var coreDataStack: CoreDataStackProto!
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func getDataFromStorage(completion: ([ChannelDB]) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChannelDB")
        let dateSort = NSSortDescriptor(key: "lastActivity", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        let mainContext = coreDataStack.mainContext
        
        do {
            guard let channelsDB = try mainContext.fetch(fetchRequest) as? [ChannelDB] else { return }
            completion(channelsDB)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func loadProfileInformation(completion: @escaping (ProfileInformation) -> Void) {
        coreDataStack.mainContext.perform {
            do {
                let array = try self.coreDataStack.mainContext.fetch(ProfileInfoDB.fetchRequest()) as? [ProfileInfoDB] ?? []
                guard let profileDB = array.first,
                      let name = profileDB.name
                else {
                    let profileInrofmation = ProfileInformation(name: "",
                                                                description: nil,
                                                                imageData: nil)
                    completion(profileInrofmation)
                    return
                }
                
                let profileInrofmation = ProfileInformation(name: name,
                                                            description: profileDB.profileInformation,
                                                            imageData: profileDB.profileImageData)
                completion(profileInrofmation)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveProfileInformation(with profInfo: ProfileInformation, completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            self.coreDataStack.performSave { context in
                _ = ProfileInfoDB(profileInfo: profInfo, context: context)
                completion()
            }
        }
    }
    
}
