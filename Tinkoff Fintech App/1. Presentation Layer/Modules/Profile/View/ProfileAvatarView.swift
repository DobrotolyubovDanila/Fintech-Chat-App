//
//  ProfileAvatarView.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 01.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class ProfileAvatarView: UIView {

    @IBOutlet weak public var profileImageButton: UIButton!
    @IBOutlet weak public var profileImageView: UIImageView!
    @IBOutlet weak public var profileLabel: UILabel!
    
    func setCornerRadius(cornerRadius: CGFloat) {
        profileLabel.layer.cornerRadius = cornerRadius
        profileImageView.layer.cornerRadius = cornerRadius
        profileImageButton.layer.cornerRadius = cornerRadius
        self.layer.cornerRadius = cornerRadius
    }
    
    func setImage(image: UIImage?) {
        guard let image = image else { return }
        
        profileImageView.image = image
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileLabel.isHidden = true
        profileLabel.text = nil
    }
}
