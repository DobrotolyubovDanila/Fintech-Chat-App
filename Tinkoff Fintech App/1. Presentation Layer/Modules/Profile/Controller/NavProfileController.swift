//
//  NavProfileController.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 07.12.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class NavProfileController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function, "navProfileContr")
        self.transitioningDelegate = self
    }

}

extension NavProfileController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print(#function)
        return CustomTransition(animationDuration: 4, animationType: .present)
    }
}
