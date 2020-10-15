//
//  LoadOperation.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 15.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class LoadOperation: Operation {
    
    var profileInformation: ProfileInformation!
    
    private var plistURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("ProfileData.plist")
    }
    
    
    override func main() {
        if isCancelled { return }
        
        profileInformation = loadProfileInformation()
    }
    
    
    func loadProfileInformation() -> ProfileInformation {
        
        let decoder = PropertyListDecoder()
        
        guard let data = try? Data(contentsOf: plistURL),
              let profInfo = try? decoder.decode(ProfileInformation.self, from: data) else {
            return ProfileInformation(name: "", description: "information", imageData: Data())
        }
        
        return profInfo
    }
    
}
