//
//  RootAssembly.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 20.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import Foundation

class RootAssembly {
    
    lazy var presentationAssembly: PresentationAssemblyProto = PresentationAssembly(serviceAssembly: servicesAssembly)
    
    private lazy var servicesAssembly: ServicesAssemblyProto = ServicesAssembly(coreAssebmly: coreAssebmly)
    
    private lazy var coreAssebmly: CoreAssemblyProto = CoreAssembly()
}
