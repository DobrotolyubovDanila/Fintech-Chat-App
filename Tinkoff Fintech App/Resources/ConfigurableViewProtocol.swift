//
//  ConfigurableView.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 30.09.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

protocol ConfigurableView {

    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}
