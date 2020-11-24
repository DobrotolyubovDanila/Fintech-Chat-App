//
//  ConversationCell.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 01.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configCell(isIncome: Bool, message: MessageDB) {
        let themeManager = ThemeManager.shared.current
        self.backgroundColor = themeManager.backgroundColor
        
        self.view.layer.cornerRadius = 20
        
        if isIncome {
            self.view.backgroundColor = themeManager.incomeMessagesBackgroundColor
            self.contentLabel.textColor = themeManager.incomeMessagesTextColor
            self.nameLabel.textColor = themeManager.secondaryTextColor
            
            self.contentLabel.text = message.content
            self.nameLabel.text = message.senderName
            
        } else {
            self.view.backgroundColor = themeManager.sendedMessagesBackgroundColor
            self.contentLabel.textColor = themeManager.sendedMessagesTextColor
            
            self.contentLabel.text = message.content
        }
    }
    
}

extension ConversationCell: ConfigurableView {
    typealias ConfigurationModel = Int
    
    func configure(with model: Int) {
        
    }
}
