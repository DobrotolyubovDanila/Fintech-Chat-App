//
//  InterfaceStyle.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 07.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation

enum InterfaceStyle {
    case classic
    case day
    case night
    
    var description: String {
        switch self {
        case .classic:
            return "ClassicTheme"
        case .day:
            return "DayTheme"
        case .night:
            return "NightTheme"
        }
    }
}
