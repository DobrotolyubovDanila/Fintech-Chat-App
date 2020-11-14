import UIKit
import CoreData

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var newMessageView: UIView!
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var identifierChannel: String!
    
    var storageManager: StorageManager!
    
    let udid = UIDevice.current.identifierForVendor?.uuidString
    
    var profileName = ""
    
    private lazy var fetchedResultsController: NSFetchedResultsController<MessageDB> = {
        let request: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        request.predicate = NSPredicate(format: "identifierChannel = %@", self.identifierChannel)
        request.sortDescriptors = [sortDescriptor]
        request.resultType = .managedObjectResultType
        
        let context = storageManager.coreDataStack.mainContext
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    private var isKeyboardThere = false
    
    private var localKeyboardHeight: CGFloat = 0
    
    private var countOfScrolls = 0
    
    lazy var messagesFBDM = MessagesFBDataManager(idChannel: identifierChannel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.keyboardDismissMode = .none
        
        configKeyboardObservers()
        
        view.backgroundColor = ThemeManager.shared.current.backgroundColor
        tableView.backgroundColor = ThemeManager.shared.current.backgroundColor
        newMessageView.backgroundColor = ThemeManager.shared.current.backgroundColor
        messageField.backgroundColor = ThemeManager.shared.current.secondBackgroundColor
        messageField.textColor = ThemeManager.shared.current.sendedMessagesTextColor
        messageField.keyboardAppearance = ThemeManager.shared.current.style == .night ? .dark : .default
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        updateDataFromFB()
    }
    
    func updateDataFromFB() {
        print(#function)
        messagesFBDM.getMessages { [weak self] (addedMessagesFB) in
            self?.storageManager.coreDataStack.performSave { (context) in
                let messagesDB = self?.fetchedResultsController.fetchedObjects ?? []
                
                for messageFB in addedMessagesFB {
                    if messagesDB.contains(where: { $0.identifierMessage == messageFB.identifierMessage }) {
                        continue
                    } else {
                        _ = messageFB.makeMessageDBModel(context: context)
                    }
                }
            }
            self?.scrollToBottom()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        guard let messageContent = messageField.text,
              let udid = udid else { return }
        
        messagesFBDM.sendMessage(content: messageContent,
                                 senderId: udid,
                                 senderName: profileName) { [weak self] in
            self?.messageField.text = nil
            guard let countOfRow = self?.tableView.numberOfRows(inSection: 0) else { return }
            let indexPath = IndexPath(row: countOfRow - 1, section: 0)
            self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    deinit {
        print("deinitConversationVC")
    }
    
    private func configKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        print("клава должна появиться")
        if !isKeyboardThere {
            
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardSize.height
                
                UIView.animate(withDuration: 0.2) {
                    self.tableViewBottomConstraint.constant += keyboardHeight - self.view.safeAreaInsets.bottom
                    self.newMessageView.frame.origin.y -= keyboardHeight - self.view.safeAreaInsets.bottom
                    
                    if self.localKeyboardHeight == 0 { self.localKeyboardHeight = keyboardHeight - self.view.safeAreaInsets.bottom }
                    self.isKeyboardThere = true
                    
                    if let indexPath = self.tableView.indexPathsForVisibleRows?.last {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(350)) {
                            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        print("клава должна скрыться")
        if isKeyboardThere {
            
            UIView.animate(withDuration: 0.2) {
                self.tableViewBottomConstraint.constant -= self.localKeyboardHeight
                self.newMessageView.frame.origin.y += self.localKeyboardHeight
                self.isKeyboardThere = false
            }
        }
    }
    
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let senderId = fetchedResultsController.fetchedObjects?[indexPath.row].senderId else { return UITableViewCell() }
        
        if  senderId != udid {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "receivedMessageCell") as? ConversationCell
            else { return UITableViewCell() }
            
            cell.label.text = fetchedResultsController.fetchedObjects?[indexPath.row].content
            cell.nameLabel.text = fetchedResultsController.fetchedObjects?[indexPath.row].senderName
            cell.view.layer.cornerRadius = 20
            cell.configCellTheme()
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "sendMessegesCell") as? ConversationCell
            else { return UITableViewCell() }
            
            cell.label.text = fetchedResultsController.fetchedObjects?[indexPath.row].content
            cell.nameLabel.text = profileName
            cell.view.layer.cornerRadius = 20
            cell.configCellTheme()
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messageField.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollToBottom() {
        guard let count = fetchedResultsController.fetchedObjects?.count else { return }
        if count > 0 {
            tableView.scrollToRow(at: IndexPath(row: count - 1, section: 0),
                                  at: .bottom,
                                  animated: true)
        }
    }
    
}

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.beginUpdates()
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
            }
        case .update:
            if let indexPath = indexPath {
                print("update")
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                print("delete")
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            print("default message case")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.endUpdates()
        }
}
