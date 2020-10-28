//
//  NewMessageVC.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/26.
//

import UIKit

class NewMessageVC: UITableViewController {
    
    //MARK: - Properties
    
    //a property that sotres an array of users
    private var users = [User]()
    
//    private let searchTextField: CustomTextField = {
//        let tf = CustomTextField(placeholder: "Search for a user")
//        return tf
//    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUsers()
    }
    
    //MARK: - API
    
    func fetchUsers() {
        Service.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
            print("DEBUG: New message users are \(users)")
            
        }
    }
    
    //MARK: - Helpers
    
    func setupUI() {
        view.backgroundColor = .white
        
        setupNavigationBar(withTitle: "New Message", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelBarButton))
        
        //tableview setup
        tableView.tableFooterView = UIView() // remove unnecessary separators/separator lines
        tableView.register(UserCell.self, forCellReuseIdentifier: K.userReuseIdentifier)
        tableView.rowHeight = 80
        
    }
    
    //MARK: - Subviewing
    
//    func subviewSearchTextField() {
//        navigationController?.navigationBar.addSubview(searchTextField)
//    }
    
    //MARK: - Selectors
    
    @objc func handleCancelBarButton() {
       dismiss(animated: true, completion: nil)
    }
    
}

    //MARK: - Extensions

extension NewMessageVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("DEBUG: User count is \(users.count)")
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.userReuseIdentifier, for: indexPath) as! UserCell
        
        cell.user = users[indexPath.row]
        print("DEBUG: Index row is \(indexPath.row)")
        print("DEBUG: User in array is \(users[indexPath.row].username)")
        
        return cell
    }
    
}
