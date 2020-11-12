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
    
    var idChannel: String
    
    private lazy var db = Firestore.firestore()
    
    lazy var reference = db.collection("channels/\(idChannel)/messages")
    
    init(idChannel: String) {
        self.idChannel = idChannel
    }
    
    func getMessages(completion: @escaping ([MessageFB]) -> Void) {
        
        DispatchQueue.global().async {
            
            self.reference.addSnapshotListener { (snapshot, _) in
                guard let snapshot = snapshot else { return }
                var messages: [MessageFB] = []
                
                snapshot.documentChanges.forEach { (change) in
                    if change.type == .added {
                        let messagesData = change.document.data()
                        
                        if let message = MessageFB(decodeWith: messagesData,
                                                   identifierMessage: change.document.documentID,
                                                   identifierChannel: self.idChannel) {
                            messages.append(message)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    completion(messages)
                }
            }
            
        }
        
    }
        
    func sendMessage(content: String, senderId: String, senderName: String, completion: @escaping () -> Void ) {
        
        DispatchQueue.global().async {
            
            let doc = self.reference.document()
            
            let messageFB = MessageFB(content: content,
                                      created: Date(),
                                      senderId: senderId,
                                      senderName: senderName,
                                      identifierMessage: doc.documentID,
                                      identifierChannel: self.idChannel)
            
            doc.setData(messageFB.encode()) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                completion()
            }
        }
        
    }
    
}
