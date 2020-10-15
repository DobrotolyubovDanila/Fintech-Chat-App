//
//  DataManagerDelegate.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 15.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

protocol DataManagerDelegate: class {
    func showAlert(title: String, message: String)
    func enableInterface()
}
