//
//  MessagesFBDataManager.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 21.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation
import Firebase


class MessagesFBDataManager {
    
    var idDocument:String
    
    private lazy var db = Firestore.firestore()
    
    private lazy var reference = db.collection("channels/\(idDocument)/messages")
    
    init(idDocument: String) {
        self.idDocument = idDocument
    }
    
    func getMessages(completion: @escaping (QuerySnapshot) -> Void) {
        
        DispatchQueue.global().async { [weak self] in
            self?.reference.addSnapshotListener { (querySnapshot, error) in
                guard let querySnapshot = querySnapshot else {
                    guard let error = error else { return }
                    print(error.localizedDescription)
                    return
                }
                completion(querySnapshot)
            }
        }
        
    }
    
    func sendMessage(message: Message, completion: @escaping () -> Void ) {
        
        DispatchQueue.global().async { [weak self] in
            self?.reference.addDocument(data: message.encode()) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                completion()
            }
        }
        
    }
    
}

