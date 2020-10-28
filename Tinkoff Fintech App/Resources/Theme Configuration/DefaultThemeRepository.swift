//
//  Theme.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 07.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class DefaultThemeRepository {
    
    private let selectedThemeKey = "selectedThemeKey"
    private let defaults = UserDefaults.standard
    
    func load() -> ThemeProtocol {
        guard let storedTheme = defaults.string(forKey: selectedThemeKey) else { return ClassicTheme() }
         
        return themeFromString(storedTheme)
    }
    
    func save(_ theme: ThemeProtocol) {
        defaults.setValue(theme.style.description, forKey: selectedThemeKey)
        defaults.synchronize()
    }
    
    func themeFromString(_ string: String) -> ThemeProtocol {
        switch string {
        case "ClassicTheme":
            return ClassicTheme()
        case "NightTheme":
            return NightTheme()
        case "DayTheme":
            return DayTheme()
        default:
            return ClassicTheme()
        }
    }
}
