//
//  NewMessageVC.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/26.
//

import UIKit

protocol NewMessageVCDelegate: class {
    func controller(_ controller: NewMessageVC, wantsToStartChatWith user: User)
}

class NewMessageVC: UITableViewController {
    
    //MARK: - Properties
    
    //a property that sotres an array of users
    private var users = [User]()
    weak var delegate: NewMessageVCDelegate?
    private var filteredUsers = [User]()
    
    //searching properties
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUsers()
        setupSearchController()
    }
    
    //MARK: - API
    
    func fetchUsers() {
        showLoader(true)
        Service.fetchUsers { users in
            self.showLoader(false)
            self.users = users
            self.tableView.reloadData()
//            print("DEBUG: New message users are \(users)")
            
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
    
    func setupSearchController() {
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        searchController.searchResultsUpdater = self
        definesPresentationContext = false
        
        //change the background of the SearchController
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .darkGray
            textField.backgroundColor = .white
        }
    }
    
    //MARK: - Selectors
    
    @objc func handleCancelBarButton() {
       dismiss(animated: true, completion: nil)
    }
    
}

    //MARK: - Extensions

extension NewMessageVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("DEBUG: User count is \(users.count)")
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.userReuseIdentifier, for: indexPath) as! UserCell
        cell.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        return cell
    }
}

extension NewMessageVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        //place where we call the function of the delegate protocol
        delegate?.controller(self, wantsToStartChatWith: user)
    }
}

extension NewMessageVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter({ userResult -> Bool in
            return userResult.username.contains(searchText) || userResult.fullname.contains(searchText)
        })
        self.tableView.reloadData()
    }
    
    
}
