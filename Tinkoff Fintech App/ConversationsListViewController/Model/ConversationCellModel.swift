//
//  ConversationCellModel.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 03.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation

struct ConversationCellModel {
    let name: String
    let message: String?
    let date: Date
    let isOnline: Bool
    let hasUnreadMessage: Bool
}
