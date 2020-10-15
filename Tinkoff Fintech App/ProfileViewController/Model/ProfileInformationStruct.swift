//
//  ProfileInformationClass.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 14.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class ProfileInformation: Codable  {
    var name: String
    var description: String
    var imageData: Data
    
    init(name: String, description: String?, imageData: Data?) {
        self.name = name
        self.description = description ?? "  "
        self.imageData = imageData ?? Data()
    }
}

