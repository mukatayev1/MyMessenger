//
//  ProfileVC.swift
//  MyMessenger
//
//  Created by AZM on 2020/11/03.
//

import UIKit
import Firebase

class ProfileVC: UITableViewController {
    
    //MARK: - Properties
    
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0,
                                                             width: view.frame.width,
                                                             height: 380))
    
    private var user: User? {
        didSet { headerView.user = user }
    }
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    //MARK: - Helpers
    
    func setupUI() {
        tableView.backgroundColor = .white
        tableView.tableHeaderView = headerView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.profileReuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.tableFooterView = UIView()
        
        headerView.delegate = self
    }
    
    //MARK: - API
    
    func fetchUser() {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        Service.fetchUser(withUid: currentUID) { (user) in
            self.user = user
        }
    }
    
    //MARK: - Selectors
    
}

extension ProfileVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.profileReuseIdentifier, for: indexPath)
        return cell
    }
}

extension ProfileVC: ProfileHeaderDelegate {
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    
}
