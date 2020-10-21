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
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configCellTheme() {
        self.view.backgroundColor = ThemeManager.shared.current.sendedMessagesBackgroundColor
        self.backgroundColor = ThemeManager.shared.current.backgroundColor
        self.label.textColor = ThemeManager.shared.current.sendedMessagesTextColor
    }

}

extension ConversationCell: ConfigurableView {
    typealias ConfigurationModel = Int
    
    func configure(with model: Int) {
        
    }
}
