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
    // Массивы аргументов completion по порядку: добавленные каналы, модифицированные каналы, id удаленных каналов.
    func getChannelsFromFB(completion: @escaping ([ChannelFB], [ChannelFB], [String]) -> Void) {
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.reference.addSnapshotListener { (snapshot, _) in
                print(#function)
                guard let snapshot = snapshot else { return }
                
                var addedChannels: [ChannelFB] = []
                var modifiedChannels: [ChannelFB] = []
                var deletedChannels: [String] = []
                
                snapshot.documentChanges.forEach { item in
                    if item.type == .added {
                        let identifierChannel = item.document.documentID
                        let dictData = item.document.data()
                        if let channelFB = ChannelFB(decodeWith: dictData, identifier: identifierChannel) {
                            addedChannels.append(channelFB)
                        }
                        
                    }
                    
                    if item.type == .modified {
                        let identifierChannel = item.document.documentID
                        let dictData = item.document.data()
                        if let channelFB = ChannelFB(decodeWith: dictData, identifier: identifierChannel) {
                            modifiedChannels.append(channelFB)
                        }
                    }
                    
                    if item.type == .removed {
                        deletedChannels.append(item.document.documentID)
                    }
                }
                
                DispatchQueue.main.async {
                    print("added channels: ", addedChannels.count,
                          " modified channels: ", modifiedChannels.count,
                          " deletedChannels: ", modifiedChannels.count)
                    completion(addedChannels, modifiedChannels, deletedChannels)
                }
            }
        }
    }
    
    func addChannel(channel: ChannelFB, completion: @escaping () -> Void) {
        print("отработал addChannel")
        let doc = reference.document()
        print("создали doc")
        channel.identifier = doc.documentID
        print("Взяли id док")
        doc.setData(channel.encode()) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            completion()
            print("отработал set data")
        }
    }
    
    func deleteChannel(channelId: String) {
        DispatchQueue.global().async {
            let messagesRef = self.db.collection("channels").document(channelId).collection("messages")
            messagesRef.getDocuments { (snapshot, _) in
                guard let snapshot = snapshot else { return }
                
                snapshot.documents.forEach { (message) in
                    messagesRef.document(message.documentID).delete { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            
            self.reference.document(channelId).delete { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
