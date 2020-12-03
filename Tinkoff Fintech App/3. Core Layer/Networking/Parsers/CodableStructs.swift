//
//  CodableStructs.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 03.12.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation

struct PixabayData: Codable {
    let total, totalHits: Int
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Codable {
    let id: Int
    let webformatURL: String

    enum CodingKeys: String, CodingKey {
        case id, webformatURL
    }
}
