//
//  ChannelDataManager.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 21.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation
import Firebase

class ChannelsFBDataManager {
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    func getDataFromStorage(completion: @escaping (QuerySnapshot) -> Void) {
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.reference.getDocuments { (querySnapshot, error) in
                guard let querySnapshot = querySnapshot else {
                    print(error?.localizedDescription ?? "error")
                    return
                }
                
                completion(querySnapshot)
            }
        }
        
        
    }
    
    func addChannel(data: ChannelData, completion: @escaping () -> Void) {
        
        DispatchQueue.global().async { [weak self] in
            self?.reference.addDocument(data: data.encode()) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                completion()
            }   
        }
    }
    
}

