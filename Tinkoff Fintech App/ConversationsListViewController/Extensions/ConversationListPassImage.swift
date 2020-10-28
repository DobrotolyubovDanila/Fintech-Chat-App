//
//  Extensions.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 08.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

extension ConversationsListViewController: PassProfileInformationProtocol {
    func setProfileInformation(image: UIImage?) {
        profileAvatarView.setImage(image: image)
    }
}
