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
            
            self?.channelsCellContent = []
            
            for item in querySnapshot.documents {
                
                if let channelData = Channel(decodeWith: item.data(), identifier: item.documentID) {
                    self?.channelsCellContent.append(channelData)
                }
            }
            
            
            self?.channelsCellContent.sort { (item1, item2) -> Bool in
                guard let date1 = item1.lastActivity,
                      let date2 = item2.lastActivity else { return false }
                
                return date1 > date2
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}


