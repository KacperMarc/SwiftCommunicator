import MessageKit
import InputBarAccessoryView
import UIKit

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(){
        self.senderId = UserDefaults.standard.string(forKey: "username") ?? UUID().uuidString
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    private var senderId: String
    private let webSocket = WebSocket()
    var currentSender: SenderType {
        //bedzie sender name z user defaults
        Sender(senderId: senderId , displayName: "Byczek")
        
    }
    var messages = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMessageKit()
        loadMessages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateStyle), name: .darkModeChanged, object: nil)
        updateStyle()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder() 
    }

    private func setupMessageKit() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
        messageInputBar.inputTextView.placeholder = "Napisz wiadomość..."
        messageInputBar.sendButton.title = "Wyślij"
        messageInputBar.inputTextView.isUserInteractionEnabled = true
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
       
        
        var protoMessage = MessageProto()
        protoMessage.senderID = currentSender.senderId
        protoMessage.senderName = currentSender.displayName
        protoMessage.messageID = UUID().uuidString
        protoMessage.sentDate = Int64(Date().timeIntervalSince1970)
        protoMessage.text = text
        
        do {
            let data = try protoMessage.serializedData()
            Task {
                do {
                    print(data)
                    await webSocket.sendMessage(data)
                    inputBar.inputTextView.text = ""
                    inputBar.invalidatePlugins()
                }
            }
        }
        catch {
            print("blad serializacji danych: \(error)")
        }
        
        
    }

    private func loadMessages() {
        webSocket.connect()
        webSocket.onMessageReceived = { [weak self] protoMessage in
               guard let self = self else { return }
               
               let sender = Sender(senderId: protoMessage.senderID, displayName: protoMessage.senderName)
               
               let message = Message(
                   sender: sender,
                   messageId: protoMessage.messageID,
                   sentDate: Date(timeIntervalSince1970: TimeInterval(protoMessage.sentDate)),
                   kind: .text(protoMessage.text)
               )
               
               DispatchQueue.main.async {
                   self.messages.append(message)
                   self.messagesCollectionView.reloadData()
                   self.messagesCollectionView.scrollToLastItem(animated: true)
               }
           }
    }
    @objc func updateStyle() {
            let isDark = AppSettings.isDarkmode
        
            messagesCollectionView.backgroundColor = isDark ? .black : .white
            messageInputBar.inputTextView.backgroundColor = isDark ? .black : .white
            messageInputBar.backgroundView.backgroundColor = isDark ? .black : .white

            messageInputBar.inputTextView.textColor = isDark ? .white : .black
        }
}
