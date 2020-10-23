//
//  ChatsVC.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/23.
//

import UIKit

class ChatsVC: UIViewController {
    
    //MARK: - Properties
    
    private let tableView = UITableView()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
        setupTableView()
    }
    
    //MARK: - Helpers
    
    func setupUI() {
        view.backgroundColor = .white
        
        let profileImage = UIImage(systemName: "person.crop.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(showProfile))
    }
    
    func setupNavigationBar() {
        //creating properties for simplicity
        let appearance = UINavigationBarAppearance()
        let navBar = navigationController?.navigationBar
        
        appearance.configureWithOpaqueBackground()
        //setting a navigation bar title color to white
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .systemRed
        
        navBar?.standardAppearance = appearance
        navBar?.compactAppearance = appearance
        navBar?.scrollEdgeAppearance = appearance
        
        navBar?.prefersLargeTitles = true
        navigationItem.title = "Messages"
        navBar?.tintColor = .white
        navBar?.isTranslucent = true
        
        navBar?.overrideUserInterfaceStyle = .dark
    }
    
    func setupTableView() {
        tableView.backgroundColor = .cyan
        tableView.rowHeight = 80
        tableView.frame = view.frame
        tableView.tableFooterView = UIView()
        
        //delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.cellIdentifier)
        view.addSubview(tableView)
    }
    
    //MARK: - Selectors
    
    @objc func showProfile() {
        print("Show Profile")
    }
}

//MARK: - Extensions

extension ChatsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension ChatsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = "Im here"
        return cell
    }
    
    
}
