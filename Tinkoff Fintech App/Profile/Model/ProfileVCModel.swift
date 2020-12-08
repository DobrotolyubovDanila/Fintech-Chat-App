//
//  ProfileVCModel.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 23.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

protocol ProfileVCModelProto {
    var profileImage: UIImage? { get set }
    var profileInformation: ProfileInformation? { get set }
    func saveProfileInformation(with: ProfileInformation)
}

class ProfileVCModel: ProfileVCModelProto {
    
    let storageManager: StorageManager
    
    var profileImage: UIImage?
    
    var profileInformation: ProfileInformation?
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
    
    func saveProfileInformation(with profInf: ProfileInformation) {
        storageManager.saveProfileInformation(with: profInf) {
            print("Сохранены данные профиля")
        }
    }
}
