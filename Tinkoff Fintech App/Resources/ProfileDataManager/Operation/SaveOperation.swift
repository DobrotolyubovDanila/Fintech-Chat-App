//
//  SaveOperation.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 15.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class SaveOperation: Operation {
    
    var profileInformation: ProfileInformation?
    
    var isSuccess = true
    
    private var plistURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("ProfileData.plist")
    }
    
    override func main() {
        if isCancelled { return }
        
        if let profileInformation = profileInformation {
            saveProfileInformation(with: profileInformation)
        }
        
    }
    
    func saveProfileInformation(with profInfo: ProfileInformation) {
        
        let encoder = PropertyListEncoder()
        
        if let data = try? encoder.encode(profInfo) {
            if FileManager.default.fileExists(atPath: self.plistURL.path) {
                try? data.write(to: self.plistURL)
                print("сохранили Operation")
            } else {
                FileManager.default.createFile(atPath: self.plistURL.path, contents: data, attributes: nil)
                print("создали файл Operation")
            }
        } else {
            self.isSuccess = false
        }
        
    }
    
    deinit {
        print("SaveOperationDeinit")
    }
    
}
