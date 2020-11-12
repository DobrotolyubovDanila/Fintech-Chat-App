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

class ConversationsListViewController: UITableViewController {
    
    @IBOutlet weak var profileAvatarView: ProfileAvatarView!
    
    @IBOutlet weak var addChannelButton: UIBarButtonItem!
    
    var channelsFBDM = ChannelsFBDataManager()
    
    lazy var storageManager = StorageManager(coreDataStack: CoreDataStack(dataModelName: "Chat"))
    
    private lazy var coreDataProfileManager = CoreDataProfileManager(with: storageManager.coreDataStack)
    
    var profileInformation: ProfileInformation!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<ChannelDB> = {
        let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.resultType = .managedObjectResultType
        
        let fetchedResultsControlelr = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: storageManager.coreDataStack.mainContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsControlelr.delegate = self
        
        return fetchedResultsControlelr
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if ThemeManager.shared.current.style == .night {
            return .lightContent
        }
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Loading profile
        
        coreDataProfileManager.loadProfileInformation { [weak self] profileInfo in
            DispatchQueue.main.async {
                self?.profileInformation = profileInfo
                
                if let image = UIImage(data: self?.profileInformation.imageData ?? Data()) {
                    self?.profileAvatarView.setImage(image: image)
                }
            }
        }
        
        // MARK: - Сonfiguring the interface
        
        setInterfaceTheme()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChannelDB")
        let dateSort = NSSortDescriptor(key: "lastActivity", ascending: false)
        
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error performFetch. ", error.localizedDescription)
        }
        
        updateDataFromFB()
    }
    
    func updateDataFromFB() {
        print(#function)
        channelsFBDM.getDataFromStorage { [weak self] (addedChannels, modifiedChannels, deletedChannelsIDs) in
            
            self?.storageManager.coreDataStack.performSave { (context) in
                let channelsDB = self?.fetchedResultsController.fetchedObjects ?? []
                for channelFB in addedChannels {
                    if channelsDB.contains(where: { $0.identifier == channelFB.identifier }) {
                        continue
                    } else {
                        _ = channelFB.makeChannelDBModel(context: context)
                    }
                }
                
                for channelFB in modifiedChannels {
                    let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                    request.predicate = NSPredicate(format: "identifier = %@", channelFB.identifier)
                    
                    do {
                        let channelDB = try context.fetch(request).first
                        if let channelDB = channelDB {
                            channelDB.name = channelFB.name
                            channelDB.lastMessage = channelFB.lastMessage
                            channelDB.lastActivity = channelFB.lastActivity
                        }
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
                
                for channelId in deletedChannelsIDs {
                    let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                    request.predicate = NSPredicate(format: "identifier = %@", channelId)
                    
                    do {
                        let channelDB = try context.fetch(request).first
                        if let channelDB = channelDB {
                            context.delete(channelDB)
                        }
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
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
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatOfflineCell", for: indexPath) as? ChatOfflineCell,
              let channelModel = fetchedResultsController.fetchedObjects?[indexPath.row]
        else { return UITableViewCell() }
        
        cell.configCellContent(ChannelFB(channelDB: channelModel))
        cell.configColorTheme()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let channel = fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
            let channelId = channel.identifier
            let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
            request.predicate = NSPredicate(format: "identifier = %@", channelId)
            
            storageManager.coreDataStack.performSave { (context) in
                do {
                    let channelDB = try context.fetch(request).first
                    if let channelDB = channelDB {
                        context.delete(channelDB)
                        channelsFBDM.deleteChannel(channelId: channelId)
                    }
                } catch {
                    
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var title = (tableView.cellForRow(at: indexPath) as? ChatOnlineCell)?.nameLabel.text
        
        if title == nil {
            title = (tableView.cellForRow(at: indexPath) as? ChatOfflineCell)?.nameLabel.text
        }
        
        let storyboard = UIStoryboard(name: "ConversationStoryboard", bundle: nil)
        guard let navigationController = storyboard.instantiateViewController(withIdentifier: "conversationNC") as? UINavigationController else { return }
        guard let conversationViewController = navigationController.topViewController as? ConversationViewController,
              let identifier = fetchedResultsController.fetchedObjects?[indexPath.row].identifier else { return }
        
        self.navigationController?.pushViewController(conversationViewController, animated: true)
        
        conversationViewController.title = title
        conversationViewController.identifierChannel = identifier
        conversationViewController.profileName = profileInformation.name
        conversationViewController.storageManager = storageManager
    }
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let nProfileController: UINavigationController = profileStoryboard.instantiateViewController(withIdentifier: "profileNC") as? UINavigationController else { return }
        if let pvc = nProfileController.topViewController as? ProfileViewController {
            if let image = profileAvatarView.profileImageView.image {
                pvc.profileImage = image
            }
            pvc.profileInformationDelegate = self
            pvc.profileInformation = profileInformation
            pvc.profileInfoDataManager = coreDataProfileManager
        }
        self.present(nProfileController, animated: true, completion: nil)
    }
    
    @IBAction func  unwindFromProfileVC(_ sender: UIStoryboardSegue) {
        
        if let pvc = sender.source as? ProfileViewController {
            
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
                                      handler: { [weak self] (_) in
                                        
                                        guard var name = alert.textFields?.first?.text,
                                              name != "" else { return }
                                        
                                        var check = false
                                        for char in name {
                                            if char != " " {
                                                check = true
                                                break
                                            } else {
                                                name.removeFirst()
                                            }
                                        }
                                        guard check == true else { return }
                                        
                                        let data = ChannelFB(name: name, identifier: "id", lastMessage: nil, lastActivity: nil)
                                        
                                        self?.channelsFBDM.addChannel(channel: data, completion: {  })
                                        
                                      }))
        present(alert, animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "ThemesViewController", bundle: nil)
        
        guard let navigationVC = storyboard.instantiateViewController(withIdentifier: "navigationVC") as? UINavigationController else { return }
        
        guard let themesViewController = navigationVC.topViewController as? ThemesViewController else { return }
        
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
    
    func getChannelsFromDB() {
        
    }
}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        print("### Начали что-то менять")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                print("добавили строку", newIndexPath)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
                print("обновили строку, ", indexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                print("удалили ряд ", indexPath)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                print("передвинули с ", indexPath, " до ", newIndexPath)
            }
        default:
            print("dafault channel case")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        print("### Закончили что-то менять")
    }
}
