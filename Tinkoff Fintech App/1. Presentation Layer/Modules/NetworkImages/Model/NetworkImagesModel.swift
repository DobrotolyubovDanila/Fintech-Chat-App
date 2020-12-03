//
//  NetworkImagesModel.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 03.12.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class NetworkImagesModel {
    let networkManager: NetworkImagesManager
    var urlStrings: [String] = []
    var images: [String: UIImage] = [:]
    
    init(networkManager: NetworkImagesManager) {
        self.networkManager = networkManager
    }
}
