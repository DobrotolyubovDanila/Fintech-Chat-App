//
//  DataManagerDelegate.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 15.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

protocol DataManagerAbstraction: class {
    func loadProfileInformation(completion: @escaping (ProfileInformation) -> Void )
    func saveProfileInformation(with profInfo: ProfileInformation, completion: @escaping () -> Void )
}
