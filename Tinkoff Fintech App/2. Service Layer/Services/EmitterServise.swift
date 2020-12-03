//
//  EmitterServise.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 03.12.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class EmitterServise {
    
    weak var view: UIView?
    
    lazy var emitter: CAEmitterLayer = {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .point
        emitter.renderMode = .oldestLast
        emitter.lifetime = 1
        emitter.birthRate = 1
        emitter.preservesDepth = true
        
        return emitter
    }()
    
    let cell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "tinkoffLogo")?.cgImage
        cell.velocity = 30
        cell.scale = 0.05
        cell.emissionRange = CGFloat.pi * 2
        cell.alphaSpeed = -0.3
        cell.lifetime = 3
        cell.birthRate = 1
        cell.velocityRange = 50
        
        return cell
    }()
    
    init(view: UIView) {
        self.view = view
    }
    
    func tapRecognizer(_ sender: UITapGestureRecognizer) {
        emitter.emitterPosition = sender.location(in: view)
        
        if sender.state == .recognized {
            emitter.emitterCells = [cell]
            self.view?.layer.addSublayer(emitter)
            emitter.birthRate = 1.5
            emitter.lifetime = 3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            self?.emitter.birthRate = 0
            self?.emitter.lifetime = 0
        }
    }
    
    func panRecognizer(_ sender: UIPanGestureRecognizer) {
        emitter.emitterPosition = sender.location(in: view)
        if sender.state == .began {
            emitter.emitterCells = [cell]
            self.view?.layer.addSublayer(emitter)
            emitter.birthRate = 1.5
            emitter.lifetime = 3

        } else if sender.state == .ended {
            emitter.birthRate = 0
        }
    }
    
}
