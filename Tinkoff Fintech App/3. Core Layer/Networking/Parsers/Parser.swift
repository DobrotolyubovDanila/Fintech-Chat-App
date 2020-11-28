//
//  Parcer.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 29.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation

class NetworkParser {
    static func parseStrings(data: Data) -> [String] {
        let decoder = JSONDecoder()
        guard let pixabayResp = try? decoder.decode(PixabayData.self, from: data) else { return [] }
        
        var urls = [String]()
        for hit in pixabayResp.hits {
            urls.append(hit.webformatURL)
        }
        return urls
    }
}
