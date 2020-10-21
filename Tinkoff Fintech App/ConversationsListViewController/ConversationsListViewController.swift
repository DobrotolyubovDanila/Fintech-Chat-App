//
//  ConversationsListViewController.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 30.09.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit
import Firebase

class ConversationsListViewController: UITableViewController {
    
    @IBOutlet weak var profileAvatarView: ProfileAvatarView!
    
    @IBOutlet weak var addChannelButton: UIBarButtonItem!
    
    var channelsCellContent: [Channel] = []
    
    var channelsFBDM = ChannelsFBDataManager()
    
    var gcdDataManager: DataManagerAbstraction?
    
    var operationDataManager: DataManagerAbstraction?
    
    var profileInformation: ProfileInformation!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if ThemeManager.shared.current.style == .night {
            return .lightContent
        }
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gcdDataManager = GCDDataManager()
        operationDataManager = OperationDataManager()
        
        // MARK: - Select method of loading data ⬇
        /*
         // GCD
         gcdDataManager?.loadProfileInformation { [weak self] (profInformaiton) in
         self?.profileInformation = profInformaiton
         
         if let image = UIImage(data: self?.profileInformation.imageData ?? Data()) {
         DispatchQueue.main.async {
         self?.profileAvatarView.setImage(image: image)
         }
         }
         }
         */
        
        // Закомментируйте код ниже, если раскомментировали выше.
        // Operaition
        
        operationDataManager?.loadProfileInformation(completion: { [weak self] (profileInfo) in
            self?.profileInformation = profileInfo
            
            if let image = UIImage(data: self?.profileInformation.imageData ?? Data()) {
                DispatchQueue.main.async {
                    self?.profileAvatarView.setImage(image: image)
                }
            }
        })
        
        // MARK: - Select method of loading data ⬆
        
        // MARK: - Сonfiguring the interface
        
        updateDataFromFB()
        
        setInterfaceTheme()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileAvatarView.setCornerRadius(cornerRadius: profileAvatarView.frame.height/2)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelsCellContent.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatOfflineCell", for: indexPath) as! ChatOfflineCell
            
        cell.configCellContent(channelsCellContent[indexPath.row])
        cell.configColorTheme()
            
        return cell
    }
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var title = (tableView.cellForRow(at: indexPath) as? ChatOnlineCell)?.nameLabel.text
        
        if title == nil {
            title = (tableView.cellForRow(at: indexPath) as? ChatOfflineCell)?.nameLabel.text
        }
        
        let storyboard = UIStoryboard(name: "ConversationStoryboard", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "conversationNC") as! UINavigationController
        let conversationViewController = navigationController.topViewController as! ConversationViewController
        
        self.navigationController?.pushViewController(conversationViewController, animated: true)
        
        conversationViewController.title = title
        conversationViewController.channelIdentifier = channelsCellContent[indexPath.row].identifier
    }
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let nProfileController: UINavigationController = profileStoryboard.instantiateViewController(withIdentifier: "profileNC") as! UINavigationController
        if let pvc = nProfileController.topViewController as? ProfileViewController {
            if let image = profileAvatarView.profileImageView.image {
                pvc.profileImage = image
            }
            pvc.profileInformationDelegate = self
            pvc.profileInformation = profileInformation
        }
        self.present(nProfileController, animated: true, completion: nil)
    }
    
    @IBAction func  unwindFromProfileVC(_ sender: UIStoryboardSegue){
        
        if let pvc = sender.source as? ProfileViewController, let _ = sender.destination as? ConversationsListViewController {
            
            if let image = pvc.profileAvatarView.profileImageView.image {
                
                profileAvatarView.setImage(image: image)
            }
            profileInformation = pvc.profileInformation
        }
    }
    
    // MARK: - Add channel
    
    @IBAction func addCannelButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Создать канал", message: "Введите название и сообщение", preferredStyle: .alert)
        
        alert.addTextField { (nameField) in
            nameField.autocapitalizationType = .sentences
            nameField.placeholder = "Название"
        }
        
        alert.addAction(UIAlertAction(title: "Отмена",
                                      style: .default,
                                      handler: nil))
        
        alert.addAction(UIAlertAction(title: "Добавить",
                                      style: .default,
                                      handler: { [weak self] (action) in
                                        
                                        guard let name = alert.textFields?.first?.text else { return }
                                        
                                        let data = Channel(name: name, identifier: "id", lastMessage: nil, lastActivity: nil)
                                        
                                        self?.channelsFBDM.addChannel(data: data, completion: { [weak self] in
                                            self?.updateDataFromFB()
                                        })
                                        
                                      }))
        present(alert, animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "ThemesViewController", bundle: nil)
        
        let navigationVC = storyboard.instantiateViewController(withIdentifier: "navigationVC") as! UINavigationController
        
        let themesViewController = navigationVC.topViewController as! ThemesViewController
        
        self.navigationController?.pushViewController(themesViewController, animated: true)
        themesViewController.title = "Settings"
        themesViewController.conversationListDelegate = self
        
        // MARK: - Closure
        // Повторил код обновления интерфейса вручную для наглядности
        themesViewController.closure = { [weak self] in
            self?.tableView.backgroundColor = ThemeManager.shared.current.backgroundColor
            
            self?.addChannelButton.tintColor = ThemeManager.shared.current.tintColor
            
            self?.navigationController?.navigationBar.tintColor = ThemeManager.shared.current.tintColor
            self?.navigationController?.navigationBar.barTintColor = ThemeManager.shared.current.backgroundColor
            
            self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.shared.current.mainTextColor]
            self?.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.shared.current.mainTextColor]
            self?.tableView.reloadData()
        }
    }
}
