import UIKit
import CoreData

class ConversationViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var newMessageView: UIView!
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    lazy var messagesFBDM = MessagesFBManager(idChannel: model.identifierChannel)
    
    var model: ConversationModelProto!
    
//    private var emitter: EmitterServise?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.keyboardDismissMode = .none
        
        setInterfaceStyle()
        
        configKeyboardObservers()
        
        model.setupMessagesFetchedResultController(tableView: tableView)
        
        model.getMessagesFromFB {
            self.scrollToBottom()
        }
        
//        emitter = EmitterServise(viewController: self)
//        configGestureRecognizers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        guard let messageContent = messageField.text else { return }
        
        let udid = model.udid
        
        messagesFBDM.sendMessage(content: messageContent,
                                 senderId: udid,
                                 senderName: model.profileName) { [weak self] in
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
        
        if !model.isKeyboardThere {
            
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardSize.height
                
                UIView.animate(withDuration: 0.2) {
                    self.tableViewBottomConstraint.constant += keyboardHeight - self.view.safeAreaInsets.bottom
                    self.newMessageView.frame.origin.y -= keyboardHeight - self.view.safeAreaInsets.bottom
                    
                    if self.model.localKeyboardHeight == 0 { self.model.localKeyboardHeight = keyboardHeight - self.view.safeAreaInsets.bottom }
                    self.model.isKeyboardThere = true
                    
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
        
        if model.isKeyboardThere {
            
            UIView.animate(withDuration: 0.2) {
                self.tableViewBottomConstraint.constant -= self.model.localKeyboardHeight
                self.newMessageView.frame.origin.y += self.model.localKeyboardHeight
                self.model.isKeyboardThere = false
            }
        }
    }
    
    private func setInterfaceStyle() {
        let themeManager = ThemeManager.shared.current
        view.backgroundColor = themeManager.backgroundColor
        tableView.backgroundColor = themeManager.backgroundColor
        newMessageView.backgroundColor = themeManager.backgroundColor
        messageField.backgroundColor = themeManager.secondBackgroundColor
        messageField.textColor = themeManager.sendedMessagesTextColor
        messageField.keyboardAppearance = themeManager.style == .night ? .dark : .default
        if themeManager.style == .day {
            messageField.textColor = themeManager.incomeMessagesTextColor
        } else {
            messageField.textColor = themeManager.sendedMessagesTextColor
        }
    }
    
//    private func configGestureRecognizers() {
//        let panRec = UIPanGestureRecognizer(target: self, action: #selector(panRecocnized(_:)))
//        panRec.cancelsTouchesInView = false
//        panRec.delegate = self
//        
//        tableView.addGestureRecognizer(panRec)
//        tableView.isUserInteractionEnabled = true
//    
//    }
//    
//    @objc func panRecocnized(_ sender: UIPanGestureRecognizer) {
//        emitter?.panRecognized(sender)
//    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.fetchedObjects().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let senderId = model.fetchedObjects()[indexPath.row].senderId
        let message = model.fetchedObjects()[indexPath.row]
        
        if  senderId != model.udid {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "receivedMessageCell") as? ConversationCell
            else { return UITableViewCell() }
            
            cell.configCell(isIncome: true, message: message)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "sendMessegesCell") as? ConversationCell
            else { return UITableViewCell() }
            
            cell.configCell(isIncome: false, message: message)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messageField.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollToBottom() {
        let count = model.fetchedObjects().count 
        if count > 0 && model.countOfScrolls == 0 {
            tableView.scrollToRow(at: IndexPath(row: count - 1, section: 0),
                                  at: .bottom,
                                  animated: false)
            model.countOfScrolls += 1
        }
    }
    
}
