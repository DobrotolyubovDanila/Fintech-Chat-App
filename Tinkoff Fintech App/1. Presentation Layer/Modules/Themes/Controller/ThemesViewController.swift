//
//  ThemesViewController.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 05.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var themeButtons: [UIButton]!
    
    @IBOutlet var labelsThemes: [UILabel]!
    
    var closure: (() -> Void)?
    
    var conversationListDelegate: ThemesPickerDelegate?
    
    var interfaceStyle: InterfaceStyle = ThemeManager.shared.current.style
    
    private var emitter: EmitterServise?
    
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
        
        emitter = EmitterServise(view: view)
        configGestureRecognizers()
    }
    
    // MARK: - Обработка смены тем.
    
    @IBAction func selectClassicMode(_ sender: UIButton) {
        selectCurrentButton(sender)
        ThemeManager.shared.apply(theme: ClassicTheme())
        
        if let closure = closure {
            closure()
        }
        updateInterfaceWithTheme()
    }
    
    @IBAction func selectDayMode(_ sender: UIButton) {
        selectCurrentButton(sender)
        ThemeManager.shared.apply(theme: DayTheme())
        
        if let closure = closure {
            closure()
        }
        updateInterfaceWithTheme()
    }
    
    @IBAction func selectNightMode(_ sender: UIButton) {
        selectCurrentButton(sender)
        ThemeManager.shared.apply(theme: NightTheme())
        
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
    
    // MARK: - Emitter
    private func configGestureRecognizers() {
        let panRec = UIPanGestureRecognizer(target: self, action: #selector(panRecocnized(_:)))
        panRec.cancelsTouchesInView = false
        panRec.delegate = self

        let tapRec = UITapGestureRecognizer(target: self, action: #selector(tapRecocnized(_:)))
        tapRec.cancelsTouchesInView = false
        tapRec.delegate = self
        
        view.addGestureRecognizer(tapRec)
        view.addGestureRecognizer(panRec)
    }

    @objc func panRecocnized(_ sender: UIPanGestureRecognizer) {
        emitter?.panRecognizer(sender)
    }
    
    @objc func tapRecocnized(_ sender: UITapGestureRecognizer) {
        emitter?.tapRecognizer(sender)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
