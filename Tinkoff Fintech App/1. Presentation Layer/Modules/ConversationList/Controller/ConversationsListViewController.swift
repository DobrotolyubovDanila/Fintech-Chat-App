//
//  ConversationsListViewController.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 30.09.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ConversationsListViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    var presentaionAssembly: PresentationAssemblyProto!
    
    @IBOutlet weak var profileAvatarView: ProfileAvatarView!
    
    @IBOutlet weak var addChannelButton: UIBarButtonItem!
    
    var model: ConversationsListModelProtocol!
    
    private var emitter: EmitterServise?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if ThemeManager.shared.current.style == .night {
            return .lightContent
        }
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Сonfiguring the interface
        setInterfaceTheme()
        
        model.setupFetchResultsController(tableView: tableView)
        
        model.getChannelsFromFB()
        
        emitter = EmitterServise(view: self.tableView)
        configGestureRecognizers()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileAvatarView.setCornerRadius(cornerRadius: profileAvatarView.frame.height / 2)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.fetchedObjects().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatOfflineCell", for: indexPath) as? ChatOfflineCell
        else { return UITableViewCell() }
        let channelModel = model.fetchedObjects()[indexPath.row]
        
        cell.configCellContent(ChannelFB(channelDB: channelModel))
        cell.configColorTheme()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            model.deleteChannel(indexPath: indexPath)
        }
    }
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let identifier = model.fetchedObjects()[indexPath.row].identifier
        
        guard let conversationVC = presentaionAssembly.conversationViewController(model: model, identifier: identifier) else { return }
        
        self.navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        //        guard let navProfileController = presentaionAssembly.profileViewController() else { return }
        //
        //        if let pvc = navProfileController.topViewController as? ProfileViewController {
        //            pvc.model.profileInformation = model.profileInformation
        //            pvc.model.profileImage = profileAvatarView.profileImageView.image
        //            pvc.presentationAssembly = presentaionAssembly
        //            pvc.profileInformationDelegate = self
        //        }
        //
        //        self.present(navProfileController, animated: true, completion: nil)
        
        let profInf = model.profileInformation ?? ProfileInformation(name: "", description: "", imageData: nil)
        let image = profileAvatarView.profileImageView.image
        
        guard let pvc = presentaionAssembly.profileViewController(frame: view.frame, profileInformation: profInf, image: image) else { return }
        
        pvc.profileInformationDelegate = self
        pvc.modalPresentationStyle = .custom
        
        let convert = profileAvatarView.convert(profileAvatarView.center, to: self.view)
        pvc.fromCenter = convert
        
        self.present(pvc, animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let themesViewController = presentaionAssembly.ThemesViewController() else { return }
        
        themesViewController.conversationListDelegate = self
        
        self.navigationController?.pushViewController(themesViewController, animated: true)
        
        // MARK: - Closure
        themesViewController.closure = { [weak self] in
            let themeManager = ThemeManager.shared.current
            self?.tableView.backgroundColor = themeManager.backgroundColor
            
            self?.addChannelButton.tintColor = themeManager.tintColor
            
            self?.navigationController?.navigationBar.tintColor = themeManager.tintColor
            self?.navigationController?.navigationBar.barTintColor = themeManager.backgroundColor
            
            self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: themeManager.mainTextColor]
            self?.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: themeManager.mainTextColor]
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func  unwindFromProfileVC(_ sender: UIStoryboardSegue) {
        
        if let pvc = sender.source as? ProfileViewController {
            
            if let image = pvc.profileAvatarView.profileImageView.image {
                
                profileAvatarView.setImage(image: image)
            }
            model.profileInformation = pvc.model.profileInformation
        }
    }
    
    // MARK: - Emitter
    
    private func configGestureRecognizers() {
        let panRec = UIPanGestureRecognizer(target: self, action: #selector(panRecocnized(_:)))
        panRec.cancelsTouchesInView = false
        panRec.delegate = self
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(tapRecocnized(_:)))
        tapRec.cancelsTouchesInView = false
        tapRec.delegate = self
        
        tableView.addGestureRecognizer(tapRec)
        tableView.addGestureRecognizer(panRec)
    }
    
    @objc func panRecocnized(_ sender: UIPanGestureRecognizer) {
        emitter?.panRecognizer(sender)
    }
    
    @objc func tapRecocnized(_ sender: UITapGestureRecognizer) {
        emitter?.tapRecognizer(sender)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - Add channel
    
    @IBAction func addCannelButtonPressed(_ sender: UIBarButtonItem) {
        model.addChannel { (alert) in
            present(alert, animated: true)
        }
    }
    
}
