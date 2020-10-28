import UIKit    

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var channelIdentifier: String!
    
    let udid = UIDevice.current.identifierForVendor?.uuidString
    
    var messagesArray: [Message] = []
    
    lazy var messagesFBDM = MessagesFBDataManager(idDocument: channelIdentifier)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.keyboardDismissMode = .interactive
        tableView.allowsSelection = false
        
        tableView.backgroundColor = ThemeManager.shared.current.backgroundColor
        
        updateDataFromFB()
    }
    
    func updateDataFromFB() {
        messagesFBDM.getMessages { [weak self] (querySnapshot) in
            self?.messagesArray = []
            
            for item in querySnapshot.documents {
                guard let message = Message(decodeWith: item.data()) else { return }
                
                self?.messagesArray.append(message)
            }
            self?.messagesArray.sort { $0.created < $1.created }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.scrollToBottom()
            }
        }
    }
    
    deinit {
        print("deinitConversationVC")
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if  messagesArray[indexPath.row].senderId != udid {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "receivedMessageCell") as? ConversationCell
            else { return UITableViewCell() }
            
            cell.label.text = messagesArray[indexPath.row].content
            cell.nameLabel.text = messagesArray[indexPath.row].senderName
            cell.view.layer.cornerRadius = 20
            cell.configCellTheme()
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "sendMessegesCell") as? ConversationCell
            else { return UITableViewCell() }
            
            cell.label.text = messagesArray[indexPath.row].content
            cell.nameLabel.text = messagesArray[indexPath.row].senderName
            cell.view.layer.cornerRadius = 20
            cell.configCellTheme()
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollToBottom() {
        if messagesArray.count > 0 {
        tableView.scrollToRow(at: IndexPath(row: messagesArray.count - 1, section: 0),
                              at: .bottom,
                              animated: true)
        }
    }
    
}
