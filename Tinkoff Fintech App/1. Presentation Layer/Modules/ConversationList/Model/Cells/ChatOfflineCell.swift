//
//  ChatOfflineCell.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 03.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class ChatOfflineCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    func configColorTheme() {
        let themeManager = ThemeManager.shared.current
        nameLabel.textColor = themeManager.mainTextColor
        messageLabel.textColor = themeManager.secondaryTextColor
        dateLabel.textColor = themeManager.secondaryTextColor
        self.backgroundColor = themeManager.backgroundColor
    }
    
    func configCellContent(_ content: ChannelFB) {
        var dateString = ""
        if let lastAct = content.lastActivity {
            let dateFormatter = DateFormatter()
            let isToday = Calendar.current.isDateInToday(lastAct)
            dateFormatter.dateFormat = isToday ? "HH:mm ›" : "dd.MMM ›"
            
            dateString = dateFormatter.string(from: lastAct)
        }
        
        nameLabel.text = content.name
        messageLabel.text = content.lastMessage ?? "No messages yet"
        dateLabel.text = dateString
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        
     /*   if content.hasUnreadMessage {
            messageLabel.font = UIFont(name: "HelveticaNeue-Medium", size: messageLabel.font.pointSize)
        } else {
            messageLabel.font = UIFont(name: "HelveticaNeue", size: messageLabel.font.pointSize)
        } */
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = ThemeManager.shared.current.secondBackgroundColor
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = ThemeManager.shared.current.backgroundColor
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
}

extension ChatOfflineCell: ConfigurableView {
    typealias ConfigurationModel = Int
    
    func configure(with model: Int) {
        return
    }
    
}
