//
//  ConversationListExtencion.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 08.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

extension ConversationsListViewController: ThemesPickerDelegate {
    func updateInterfaceTheme() {
        
        setInterfaceTheme()
        tableView.reloadData()
    }
    
    func setInterfaceTheme() {
        let themeManager = ThemeManager.shared.current
        self.tableView.backgroundColor = themeManager.backgroundColor
        
        self.addChannelButton.tintColor = themeManager.tintColor
        
        navigationController?.navigationBar.tintColor = themeManager.tintColor
        navigationController?.navigationBar.barTintColor = themeManager.backgroundColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: themeManager.mainTextColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: themeManager.mainTextColor]
    }
}
