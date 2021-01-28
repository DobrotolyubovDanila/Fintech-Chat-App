//
//  NetworkImageCell.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 27.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class NetworkImageCell: UICollectionViewCell {

    static let reuseIdentifier = "imageCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setImage(image: UIImage?) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print(#function)
        imageView.image = UIImage(named: "imagePlaceholder")
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "NetworkImageCell", bundle: nil)
    }
}
