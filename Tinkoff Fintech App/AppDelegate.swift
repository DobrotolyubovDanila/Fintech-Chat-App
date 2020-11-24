//
//  AppDelegate.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 10.09.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let rootAssembly: RootAssembly = RootAssembly()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ThemeManager.shared.current = DefaultThemeRepository().load()
        
        FirebaseApp.configure()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let controller = rootAssembly.presentationAssembly.conversationsListViewControlelr()
        (controller?.topViewController as? ConversationsListViewController)?.presentaionAssembly = rootAssembly.presentationAssembly
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
}
