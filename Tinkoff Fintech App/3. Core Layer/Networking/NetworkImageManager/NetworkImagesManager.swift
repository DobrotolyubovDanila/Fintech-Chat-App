//
//  NetworkImageManager.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 29.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class NetworkImagesManager {
    
    func getReferences(completion: @escaping ([String]) -> Void) {
        
        guard let url = URL(string: "https://pixabay.com/api/?key=19281671-02c972ad3ffcf4446da3cfdbd&q=yellow+cars&image_type=%20photo&pretty=true&per_page=200") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                let urls = NetworkParser.parseStrings(data: data)
                completion(urls)
            }
        }.resume()
    }
    
    func getImage(url: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            guard let url = URL(string: url),
                  let data = try? Data(contentsOf: url) else { return }
            
            completion(UIImage(data: data))
            
        }
        
    }
}
