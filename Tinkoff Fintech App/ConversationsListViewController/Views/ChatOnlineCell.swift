//
//  ChatDecsriptionCell.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 30.09.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class ChatOnlineCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var onlineIndicator: UIView!
    
    private func configOnlineIndicator() {
        onlineIndicator.layer.cornerRadius = onlineIndicator.layer.frame.height / 2
        
        let shapeLayer = CAShapeLayer()
        
        let path = UIBezierPath(arcCenter: CGPoint(x: onlineIndicator.bounds.midX,
                                                   y: onlineIndicator.bounds.midY),
                                radius: onlineIndicator.frame.height / 2 - 3,
                                startAngle: 0,
                                endAngle: CGFloat.pi * 2,
                                clockwise: true)
        
        shapeLayer.fillColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        shapeLayer.path = path.cgPath
        
        onlineIndicator.layer.addSublayer(shapeLayer)
    }
    
    func configWithTheme() {
        nameLabel.textColor = ThemeManager.shared.current.mainTextColor
        messageLabel.textColor = ThemeManager.shared.current.secondaryTextColor
        dateLabel.textColor = ThemeManager.shared.current.secondaryTextColor
        onlineIndicator.backgroundColor = ThemeManager.shared.current.backgroundColor
        self.backgroundColor = ThemeManager.shared.current.backgroundColor
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
        
        /*if content.hasUnreadMessage {
            messageLabel.font = UIFont(name: "HelveticaNeue-Medium", size: messageLabel.font.pointSize)
        } else {
            messageLabel.font = UIFont(name: "HelveticaNeue", size: messageLabel.font.pointSize)
        }*/

        configOnlineIndicator()
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

extension ChatOnlineCell: ConfigurableView {
    typealias ConfigurationModel = Int
    
    func configure(with model: Int) {
        return
    }
    
}
