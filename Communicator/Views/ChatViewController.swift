import MessageKit
import InputBarAccessoryView
import UIKit

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {

    var currentSender: SenderType {
        Sender(senderId: "self", displayName: "Byczek")
    }
    
    var otherSender: SenderType {
        Sender(senderId: "other", displayName: "PatoDev")
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
        let newMessage = Message(sender: currentSender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
        messages.append(newMessage)
        messagesCollectionView.reloadData()
        inputBar.inputTextView.text = ""
    }

    private func loadMessages() {
        messages.append(Message(sender: currentSender, messageId: "1", sentDate: Date().addingTimeInterval(-100), kind: .text("Elo byczek")))
        messages.append(Message(sender: otherSender, messageId: "2", sentDate: Date().addingTimeInterval(-200), kind: .text("snajper snajper")))
        messages.append(Message(sender: currentSender, messageId: "3", sentDate: Date().addingTimeInterval(-300), kind: .text("byczek byczek")))
        messages.append(Message(sender: otherSender, messageId: "4", sentDate: Date().addingTimeInterval(-400), kind: .text("json json")))
        messagesCollectionView.reloadData()
    }
    @objc func updateStyle() {
            let isDark = AppSettings.isDarkmode
        
            messagesCollectionView.backgroundColor = isDark ? .black : .white
            messageInputBar.inputTextView.backgroundColor = isDark ? .black : .white
            messageInputBar.backgroundView.backgroundColor = isDark ? .black : .white

            messageInputBar.inputTextView.textColor = isDark ? .white : .black
        }
}
