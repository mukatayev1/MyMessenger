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
        return iv
    }()
    
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
    }
    
    //It helps us to setup input accessory view of VC.
    override var inputAccessoryView: UIView? {
        get {return customInputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - Helpers
    
    func setupUI() {
        collectionView.backgroundColor = .white
        setupNavigationBar(withTitle: user.username, prefersLargeTitles: false)
    }

}
