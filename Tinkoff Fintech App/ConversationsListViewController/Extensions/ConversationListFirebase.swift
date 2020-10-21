//
//  ConversationListFirebase.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 21.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit


extension ConversationsListViewController {
    func updateDataFromFB() {
        channelsFBDM.getDataFromStorage { [weak self] (querySnapshot) in
            
            self?.conversationCellsContent = []
            
            for item in querySnapshot.documents {
                if let channelData = ChannelData(decodeWith: item.data()) {
                    let cellModel = ConversationCellModel(name: channelData.name,
                                                          message: channelData.lastMessage,
                                                          date: channelData.lastActivity,
                                                          isOnline: false,
                                                          hasUnreadMessage: false)
                    
                    self?.conversationCellsContent.append(cellModel)
                }
            }
            
            
            self?.conversationCellsContent.sort { (item1, item2) -> Bool in
                return item1.date > item2.date
            }
            
            self?.conversationCellsContent = (self?.conversationCellsContent.filter { $0.isOnline } ?? []) + (self?.conversationCellsContent.filter { !$0.isOnline } ?? [])
            
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}


