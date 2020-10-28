//
//  ProfileDataManager.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 15.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class GCDDataManager: DataManagerAbstraction {
    
    weak var delegate: DataUpdaterDelegate?
    
    private var plistURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("ProfileData.plist")
    }
    
    func loadProfileInformation(completion: @escaping (ProfileInformation) -> Void ) {
        
        let decoder = PropertyListDecoder()
        
        guard let data = try? Data(contentsOf: plistURL),
              let profInfo = try? decoder.decode(ProfileInformation.self, from: data) else {
            completion(ProfileInformation(name: "", description: "information", imageData: Data() ) )
            return
        }
        
        completion(profInfo)
    }
    
    func saveProfileInformation(with profInfo: ProfileInformation, completion: @escaping (Bool) -> Void ) {
        DispatchQueue.global().async {
            let encoder = PropertyListEncoder()
            
            if let data = try? encoder.encode(profInfo) {
                if FileManager.default.fileExists(atPath: self.plistURL.path) {
                    try? data.write(to: self.plistURL)
                    print("сохранили GCD")
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    FileManager.default.createFile(atPath: self.plistURL.path, contents: data, attributes: nil)
                    DispatchQueue.main.async {
                        completion(true)
                    }
                    
                }
            } else {
                completion(false)
            }
        }
    }
    
}
