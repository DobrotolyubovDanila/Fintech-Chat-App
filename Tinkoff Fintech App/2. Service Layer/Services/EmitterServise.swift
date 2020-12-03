//
//  EmitterServise.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 03.12.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class EmitterServise {
    
    weak var viewController: UIViewController?
    
    lazy var emitter: CAEmitterLayer = {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .point
        emitter.renderMode = .oldestLast
        emitter.lifetime = 1
        emitter.birthRate = 1
        return emitter
    }()
    
    let cell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.velocity = 15
        cell.scale = 0.01
        //        cell.scaleRange = 0.25
        
        cell.emissionRange = CGFloat.pi * 2
        cell.contents = UIImage(named: "tinkoffLogo")?.cgImage
        
        cell.lifetime = 5
        cell.birthRate = 1
        return cell
    }()
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func panRecognized(_ sender: UIPanGestureRecognizer) {
        emitter.emitterPosition = sender.location(in: viewController?.view)
        print("отработал рекогн")
        if sender.state == .began {
            emitter.emitterCells = [cell]
            viewController?.view.layer.addSublayer(emitter)
            emitter.birthRate = 1
            emitter.lifetime = 1

        } else if sender.state == .ended {
            emitter.birthRate = 0
            emitter.removeFromSuperlayer()
        }
    }
    
}
