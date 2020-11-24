//
//  NavController.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 14.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class NavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if ThemeManager.shared.current.style == .night {
            return UIStatusBarStyle.lightContent
        } else {
            return .default
        }
    }

}
