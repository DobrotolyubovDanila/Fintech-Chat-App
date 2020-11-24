//
//  DayTheme.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 07.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class DayTheme: ThemeProtocol {
    
    var style: InterfaceStyle = .day
    
    var backgroundColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    var secondBackgroundColor: UIColor = #colorLiteral(red: 0.8855729699, green: 0.8828242421, blue: 0.8877296448, alpha: 1)
    
    var tintColor: UIColor = UIColor.systemBlue
    
    var mainTextColor: UIColor = .black
    
    var secondaryTextColor: UIColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    
    var incomeMessagesBackgroundColor: UIColor = #colorLiteral(red: 0.8595830798, green: 0.8569152951, blue: 0.8616765141, alpha: 1)
    
    var sendedMessagesBackgroundColor: UIColor = #colorLiteral(red: 0.264976263, green: 0.5361477733, blue: 0.9749037623, alpha: 1)
    
    var incomeMessagesTextColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    var sendedMessagesTextColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
}
