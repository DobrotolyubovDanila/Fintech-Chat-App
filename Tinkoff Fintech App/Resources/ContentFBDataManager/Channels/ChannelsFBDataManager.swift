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
    lazy var reference = db.collection("channels")
    
    func getDataFromStorage(completion: @escaping (QuerySnapshot) -> Void) {
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            
            self?.reference.addSnapshotListener { (querySnapshot, error) in
                    guard let querySnapshot = querySnapshot else {
                        print(error?.localizedDescription ?? "error")
                        return
                    }
                    print("изменения")
                    completion(querySnapshot)
                }
            }
    }
    
    func addChannel(data: Channel, completion: @escaping () -> Void) {
        
        DispatchQueue.global().async { [weak self] in
            
            guard let doc = self?.reference.document() else { return }
            data.identifier = doc.documentID
            doc.setData(data.encode()) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                completion()
            }
        }
    }
    
}
