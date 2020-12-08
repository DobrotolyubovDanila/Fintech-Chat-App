//
//  CustoumTransition.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 05.12.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class CustomTransition: NSObject {
    private let duration: Double
    private let animationType: AnimationType
    var fromCenter: CGPoint?
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    init(animationDuration: Double, animationType: AnimationType) {
        self.duration = animationDuration
        self.animationType = animationType
    }
}

extension CustomTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: duration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        print(animationType)
        print(#function)
        switch animationType {
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            presentAnimation(with: transitionContext, viewToAnimate: toViewController.view)
        case .dismiss:
            transitionContext.containerView.addSubview(fromViewController.view)
            transitionContext.containerView.bringSubviewToFront(toViewController.view)
            
            dismissAnimation(with: transitionContext, viewToAnimate: fromViewController.view)
        }
    }
    
    func presentAnimation(with traisitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        viewToAnimate.clipsToBounds = true
        viewToAnimate.transform = CGAffineTransform(scaleX: 0, y: 0)
        viewToAnimate.alpha = 0
        
        let originalCenter = viewToAnimate.center
        let duration = transitionDuration(using: traisitionContext)
        
        if let fromCenter = fromCenter {
            viewToAnimate.center = fromCenter
        }
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut) {
            viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
            viewToAnimate.center = originalCenter
            viewToAnimate.alpha = 1
        } completion: { (_) in
            traisitionContext.completeTransition(true)
        }

    }
    
    func dismissAnimation(with traisitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        
        let duration = transitionDuration(using: traisitionContext)
        print("dismiss")
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.7,
                       options: .curveEaseInOut) {

            viewToAnimate.alpha = 0
            viewToAnimate.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        } completion: { (_) in
            traisitionContext.completeTransition(true)
        }
    }
}
