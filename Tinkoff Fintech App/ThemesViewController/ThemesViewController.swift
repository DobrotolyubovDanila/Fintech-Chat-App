//
//  ThemesViewController.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 05.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    @IBOutlet var themeButtons: [UIButton]!
    
    @IBOutlet var labelsThemes: [UILabel]!
    
    var closure: (() -> Void)?
    
    var conversationListDelegate: ThemesPickerDelegate?
    
    var interfaceStyle: InterfaceStyle = ThemeManager.shared.current.style
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch interfaceStyle {
        case .classic:
            selectCurrentButton(themeButtons[0])
        case .day:
            selectCurrentButton(themeButtons[1])
        case .night:
            selectCurrentButton(themeButtons[2])
        }
        
        updateInterfaceWithTheme()
    }
    
    // MARK: - Комментарий. Обработка смены тем.
    /*
     Код метода делегата закомментирован.
     - retyne cycle может возникнуть в случае захвата контроллера замыканием
     - в случае, если не произойдет деинициализация ThemesViewController
     */
    @IBAction func selectClassicMode(_ sender: UIButton) {
        selectCurrentButton(sender)
        ThemeManager.shared.apply(theme: ClassicTheme())
        
//        conversationListDelegate?.updateInterfaceWithTheme()
        
        if let closure = closure {
            closure()
        }
        updateInterfaceWithTheme()
    }
    
    @IBAction func selectDayMode(_ sender: UIButton) {
        selectCurrentButton(sender)
        ThemeManager.shared.apply(theme: DayTheme())
        
//        conversationListDelegate?.updateInterfaceWithTheme()
        
        if let closure = closure {
            closure()
        }
        updateInterfaceWithTheme()
    }
    
    @IBAction func selectNightMode(_ sender: UIButton) {
        selectCurrentButton(sender)
        ThemeManager.shared.apply(theme: NightTheme())
        
//        conversationListDelegate?.updateInterfaceWithTheme()
        
        if let closure = closure {
            closure()
        }
        updateInterfaceWithTheme()
    }
    
    private func selectCurrentButton(_ button: UIButton) {
        for item in themeButtons where item != button {
            item.isSelected = false
        }
        button.isSelected = true
    }
    
    func updateInterfaceWithTheme() {
        view.backgroundColor = ThemeManager.shared.current.backgroundColor
        labelsThemes.forEach { $0.textColor = ThemeManager.shared.current.mainTextColor }
        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    deinit {
        print("deinit ThemeVC")
    }
}
