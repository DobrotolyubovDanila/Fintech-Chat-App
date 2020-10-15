//
//  OperationDataManager.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 15.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class OperationDataManager: DataManagerAbstraction {
    
    weak var delegate: DataUpdaterDelegate?
    
    func saveProfileInformation(with profInfo: ProfileInformation, completion: @escaping ()->() ) {
        print("Save with Operation")
        
        let saveOperation = SaveOperation()
        saveOperation.profileInformation = profInfo
        saveOperation.delegate = delegate
        
        saveOperation.completionBlock = {
            DispatchQueue.main.async {
                completion()
                self.delegate?.showAlert(title: "Success", message: "Data was written to the file with Operation")
            }
        }
        OperationQueue().addOperation(saveOperation)
    }
    
    
    func loadProfileInformation(completion: @escaping (ProfileInformation) -> () ) {
        let loadOperation = LoadOperation()
        
        loadOperation.completionBlock = {
            DispatchQueue.main.async {
                completion(loadOperation.profileInformation)
            }
        }
        OperationQueue().addOperation(loadOperation)
    }
}
