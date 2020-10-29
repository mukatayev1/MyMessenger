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
        self.hideKeyboardWhenTappedAround()
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
        
        return cell
    }
}

//A delegate for setting the Collection view cell setup
extension ChatsCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    } 
}


//a delegate for sending message from custom input accessory view.
extension ChatsCollectionVC: CustomInputAccessoryViewDelegate {
    
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        
        fromCurrentUser.toggle()
        inputView.messageInputView.text = nil
        let message = Message(text: message, isFromCurrentUser: fromCurrentUser)
        messages.append(message)
        
        //in order to scroll the view when message is sent
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    
    
}
