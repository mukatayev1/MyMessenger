//
//  ChatsVC.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/23.
//

import UIKit
import Firebase

class ConversationsVC: UIViewController {
    
    //MARK: - Properties
    
    private let tableView = UITableView()
    
    private var conversations = [Conversation]()
    
    private var conversationsDictionary = [String: Conversation]()
    
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(K.plusImage, for: .normal)
        button.backgroundColor = .systemRed
        button.tintColor = .white
        button.imageView?.setDimensions(height: 24, width: 24)
        button.addTarget(self, action: #selector(handleNewMessageButton), for: .touchUpInside)
        return button
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        authenticateUser()
        fetchConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
    }
    
    //MARK: - API
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
//            print("DEBUG: User isn't logged in. Present the login screen")
            presentLoginScreen()
        }
    }
    
    func fetchConversations() {
        showLoader(true)
        Service.fetchConversations { (conversations) in
            
            conversations.forEach { (conversation) in
                let message = conversation.message
                self.conversationsDictionary[message.chatPartnerID] = conversation
            }
            self.showLoader(false)
            
            self.conversations = Array(self.conversationsDictionary.values)
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginVC()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
            
            controller.delegate = self
        }
    }
    
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            presentLoginScreen()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        setupTableView()
        
        let profileImage = K.profileImage
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(showProfile))
        
        //subviews
        subviewNewMessageButton()
    }
    
    func setupTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.frame = view.frame
        tableView.tableFooterView = UIView()
        
        //delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ConversationCell.self, forCellReuseIdentifier: K.chatsReuseIdentifier)
        view.addSubview(tableView)
    }
    
    func showChatController(forUser user: User) {
        let controller = ChatsCollectionVC(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Subviewing
    
    func subviewNewMessageButton() {
        view.addSubview(newMessageButton)
        newMessageButton.setDimensions(height: 56, width: 56)
        newMessageButton.layer.cornerRadius = 56 / 2
//        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 24)
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 24)
    }
    
    //MARK: - Selectors
    
    @objc func showProfile() {
        let controller = ProfileVC(style: .insetGrouped)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
        controller.delegate = self
    }
    
    @objc func handleNewMessageButton() {
        let controller = NewMessageVC()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

//MARK: - Extensions

extension ConversationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user

        showChatController(forUser: user)
    }
}

extension ConversationsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.chatsReuseIdentifier, for: indexPath) as! ConversationCell
        
        cell.conversation = conversations[indexPath.row]
        
        return cell
    }
}

//MARK: - NewMessageVC Delegate

extension ConversationsVC: NewMessageVCDelegate {
    func controller(_ controller: NewMessageVC, wantsToStartChatWith user: User) {
        //place the function of NewMessage delegate gets performed.
        dismiss(animated: true, completion: nil)
        showChatController(forUser: user)
    }
}

//MARK: - ProfileVC Delegate

extension ConversationsVC: ProfileVCDelegate {
    func handleLogout() {
        logout()
    }
}

extension ConversationsVC: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        setupUI()
        fetchConversations()
    }
}
