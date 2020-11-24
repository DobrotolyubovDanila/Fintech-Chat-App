//
//  PresentationAssembly.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 19.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

protocol PresentationAssemblyProto {
    func conversationsListViewControlelr() -> NavController?
    
    func conversationViewController(model: ConversationsListModelProtocol, identifier: String) -> ConversationViewController?
    
    func profileViewController() -> UINavigationController?
    
    func ThemesViewController() -> ThemesViewController?
}

class PresentationAssembly: PresentationAssemblyProto {
    
    private let serviceAssebmly: ServicesAssemblyProto
    
    init(serviceAssembly: ServicesAssemblyProto) {
        self.serviceAssebmly = serviceAssembly
    }
    
    func conversationsListViewControlelr() -> NavController? {
        let storyboard = UIStoryboard(name: "ConversationsList", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavController") as? NavController
        let conversationsListViewController = navigationController?.topViewController as? ConversationsListViewController
        let model = ConversationsListModel(storageService: serviceAssebmly.storageService,
                                           firebaseService: serviceAssebmly.channelFBService,
                                           channelsFetchedResultsService: serviceAssebmly.channelsFetchedResultsService())
        conversationsListViewController?.model = model
        
        model.loadProfileInformation { profileInfo in
            DispatchQueue.main.async {
                model.profileInformation = profileInfo
                if let image = UIImage(data: model.profileInformation?.imageData ?? Data()) {
                    conversationsListViewController?.profileAvatarView.setImage(image: image)
                }
            }
        }
        
        return navigationController
    }
    
    func profileViewController() -> UINavigationController? {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let navProfileController = profileStoryboard.instantiateViewController(withIdentifier: "profileNC") as? UINavigationController
        
        if let pvc = navProfileController?.topViewController as? ProfileViewController {
            pvc.model = ProfileVCModel(storageManager: serviceAssebmly.storageService.storageManager)
        }
        
        return navProfileController
    }
    
    func conversationViewController(model: ConversationsListModelProtocol, identifier: String) -> ConversationViewController? {
        
        let storyboard = UIStoryboard(name: "ConversationStoryboard", bundle: nil)
        guard let navigationController = storyboard.instantiateViewController(withIdentifier: "conversationNC") as? UINavigationController,
              let conversationViewController = navigationController.topViewController as? ConversationViewController else { return nil }
        
        let channel = model.fetchedObjects().first(where: { (channel) -> Bool in
            channel.identifier == identifier
        })
        
        conversationViewController.title = channel?.name
        
        conversationViewController.model = ConversationModel(identifierChannel: identifier,
                                                             messagesFetchedResultsService: serviceAssebmly.messagesFetchedResultsService(identifierChannel: identifier),
                                                             firebaseService: serviceAssebmly.messagesFBService(idChannel: identifier),
                                                             storageService: serviceAssebmly.storageService)
        
        conversationViewController.model.profileName = model.profileInformation?.name ?? ""
        
        return conversationViewController
    }
    
    func ThemesViewController() -> ThemesViewController? {
        let storyboard = UIStoryboard(name: "ThemesViewController", bundle: nil)
        
        guard let navigationVC = storyboard.instantiateViewController(withIdentifier: "navigationVC") as? UINavigationController else { return nil }
        
        guard let themesViewController = navigationVC.topViewController as? ThemesViewController else { return nil }
        
        themesViewController.title = "Settings"
        
        return themesViewController
    }
}
