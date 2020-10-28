//
//  NightTheme.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 07.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class NightTheme: ThemeProtocol {
    
    var style: InterfaceStyle = .night
    
    var backgroundColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    var secondBackgroundColor: UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    
    var tintColor: UIColor = UIColor.systemBlue
    
    var mainTextColor: UIColor = .white
    
    var secondaryTextColor: UIColor = .gray
    
    var incomeMessagesBackgroundColor: UIColor = #colorLiteral(red: 0.1803726554, green: 0.1804046035, blue: 0.1803656518, alpha: 1)
    
    var sendedMessagesBackgroundColor: UIColor = #colorLiteral(red: 0.3607499003, green: 0.3608062863, blue: 0.3607375622, alpha: 1)
    
    var incomeMessagesTextColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    var sendedMessagesTextColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
}
