//
//  ViewController.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 10.09.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let callBy = #function
        printFuncVC(controller: "SecondVC", callByFunc: callBy)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let callBy = #function
        printFuncVC(controller: "SecondVC", callByFunc: callBy)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let callBy = #function
        printFuncVC(controller: "SecondVC", callByFunc: callBy)
    }
    
    override func viewWillLayoutSubviews() {
        let callBy = #function
        printFuncVC(controller: "SecondVC", callByFunc: callBy)
    }
    
    override func viewDidLayoutSubviews() {
        let callBy = #function
        printFuncVC(controller: "SecondVC", callByFunc: callBy)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let callBy = #function
        printFuncVC(controller: "SecondVC", callByFunc: callBy)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        let callBy = #function
        printFuncVC(controller: "SecondVC", callByFunc: callBy)
    }
    
}

