//
//  CoreDataProfileManager.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 29.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation
import CoreData

class CoreDataProfileManager: DataManagerAbstraction {
    
    private var coreDataStack: CoreDataStack!
    
    private var mainContext: NSManagedObjectContext!
    
    init(with coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.mainContext = coreDataStack.mainContext
    }
    
    func loadProfileInformation(completion: @escaping (ProfileInformation) -> Void) {
        mainContext.perform {
            do {
                let array = try self.mainContext.fetch(ProfileInfoDB.fetchRequest()) as? [ProfileInfoDB] ?? []
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
