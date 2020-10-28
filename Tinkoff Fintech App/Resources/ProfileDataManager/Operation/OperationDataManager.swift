//
//  OperationDataManager.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 15.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class OperationDataManager: DataManagerAbstraction {
    
    func saveProfileInformation(with profInfo: ProfileInformation, completion: @escaping (Bool) -> Void) {
        print("Save with Operation")
        
        let saveOperation = SaveOperation()
        saveOperation.profileInformation = profInfo
        
        saveOperation.completionBlock = {
            completion(saveOperation.isSuccess)
        }
        OperationQueue().addOperation(saveOperation)
    }
    
    func loadProfileInformation(completion: @escaping (ProfileInformation) -> Void ) {
        let loadOperation = LoadOperation()
        
        loadOperation.completionBlock = {
            completion(loadOperation.profileInformation)
        }
        OperationQueue().addOperation(loadOperation)
    }
}
