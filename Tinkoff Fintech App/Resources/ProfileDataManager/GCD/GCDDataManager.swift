//
//  ProfileDataManager.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 15.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class GCDDataManager {
    
    weak var delegate: DataManagerDelegate?
    
    private var plistURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("ProfileData.plist")
    }
    
    func getProfileInformation() -> ProfileInformation {
        
        let decoder = PropertyListDecoder()
        
        guard let data = try? Data(contentsOf: plistURL),
              let profInfo = try? decoder.decode(ProfileInformation.self, from: data) else {
            return ProfileInformation(name: "", description: "information", imageData: Data())
        }
        
        return profInfo
    }
    
    
    
    func saveProfileInformation(with profInfo: ProfileInformation) {
        DispatchQueue.global().async {
            let encoder = PropertyListEncoder()
            
            if let data = try? encoder.encode(profInfo) {
                if FileManager.default.fileExists(atPath: self.plistURL.path) {
                    try? data.write(to: self.plistURL)
                    print("сохранили GCD")
                    DispatchQueue.main.async {
                        self.delegate?.showAlert(title: "Success", message: "Data was written to the file with GCD")
                        self.delegate?.enableInterface()
                    }
                } else {
                    FileManager.default.createFile(atPath: self.plistURL.path, contents: data, attributes: nil)
                    DispatchQueue.main.async {
                        self.delegate?.showAlert(title: "Success", message: "the data was written to the file")
                        self.delegate?.enableInterface()
                    }
                }
            } else {
                self.delegate?.showAlert(title: "Failing save", message: "Failed to save data")
            }
        }
    }
    
}
