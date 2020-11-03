//
//  ChatsCollectionVC.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/28.
//

import UIKit

class ChatsCollectionVC: UICollectionViewController {
    
    //MARK: - Properties
    
    private let user: User
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        iv.delegate = self
        return iv
    }()
    
    private var messages = [Message]()
    var fromCurrentUser = false
    
    //MARK: - Lifecycle
    
    //custom initializer for creating a user that we're chatting with.
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print("User in chatVC\(user.username)")
        fetchMessages()
    }
    
    //It helps us to setup input accessory view of VC.
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - Helpers
    
    func setupUI() {
        collectionView.backgroundColor = .white
        setupNavigationBar(withTitle: user.username, prefersLargeTitles: false)
        
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: K.messageReuseIdentifier)
        collectionView.alwaysBounceVertical = true
        
        collectionView.keyboardDismissMode = .interactive
    }
    
    //MARK: - API
    
    func fetchMessages() {
        Service.fetchMessages(forUser: user) { (messages) in
            self.messages = messages
            self.collectionView.reloadData()
            
            //func to automatically scroll the collectionView down to the latest messages that was sent.
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1],
                                             at: .bottom, animated: true)
        }
    }
    

}

//an extension for working with collection view
extension ChatsCollectionVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.messageReuseIdentifier, for: indexPath) as! MessageCell
        
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        
        return cell
    }

}

//MARK: - Extensions

//A delegate for setting the Collection view cell setup
extension ChatsCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    
    //Here we work with cells that are populated with Message Cells. And inside of this func, we define the dynamic sizing of the messages.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let phoneWidth = view.frame.width
        //creating a dummy size
        let myFrame = CGRect(x: 0, y: 0, width: phoneWidth, height: 50)
        let estimatedSizeCell = MessageCell(frame: myFrame)
        //defining .message of the cell.
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        //Utilizing a dynamic sizing for the target size.
        //initialize targetSize
        let targetSize = CGSize(width: phoneWidth, height: 1000)
        //Use targetSize for .systemLayoutSizeFitting(). It figures how tall the cell should be based on the estimatedSizeCell that is populated with some message.
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: phoneWidth, height: estimatedSize.height)
        
    } 
}


//a delegate for sending message from custom input accessory view.
extension ChatsCollectionVC: CustomInputAccessoryViewDelegate {
    
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        
        //a func to uploaad messages to database.
        Service.uploadMessage(message, to: user) { (error) in
            if let error = error {
                print("DEBUG: Failed to upload the message. Error: \(error)")
                return
            }
        }
        
        inputView.clearMessageText()
        
    }
    
}
