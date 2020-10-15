//
//  LogFunc.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 13.09.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

// Данный файл содержит глобальные функции, с помощью которых выводятся логи.

import Foundation


class Logger {
    
    private init () {}
    
    static var printLogsIndicator = true // Переведите в состояние false, если требуется отключить логи.

    static func printApplicationState(from status1: String, to status2: String, callByFunc: String) {
        if printLogsIndicator {
            print()
            print("Application moved from \(status1) to \(status2): \(callByFunc)")
            print()
        }
    }

    static func printFuncVC(controller: String, callByFunc: String) {
        if printLogsIndicator {
            print(controller, "\t called ", callByFunc)
        }
    }
}

