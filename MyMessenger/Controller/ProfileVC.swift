//
//  ProfileVC.swift
//  MyMessenger
//
//  Created by AZM on 2020/11/03.
//

import UIKit
import Firebase

protocol ProfileVCDelegate: class {
    func handleLogout()
}

class ProfileVC: UITableViewController {
    
    //MARK: - Properties
    
    weak var delegate: ProfileVCDelegate?
    
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0, width: view.frame.width, height: 380))
    
    private var user: User? {
        didSet { headerView.user = user }
    }
    
    private let footerView = ProfileFooter()
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUser()
        
        footerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    //MARK: - Helpers
    
    func setupUI() {
        tableView.backgroundColor = .systemGroupedBackground
        tableView.tableHeaderView = headerView
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 64
        tableView.register(ProfileCell.self, forCellReuseIdentifier: K.profileReuseIdentifier)
        
        headerView.delegate = self
        
        footerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
    }
    
    //MARK: - API
    
    func fetchUser() {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        Service.fetchUser(withUid: currentUID) { (user) in
            self.user = user
        }
    }
}

//MARK: - UITableViewDataSource

extension ProfileVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileVM.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.profileReuseIdentifier, for: indexPath) as! ProfileCell
        let viewModel = ProfileVM(rawValue: indexPath.row)
        cell.viewModel = viewModel
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none

        return cell
    }
}

// MARK: - UITableViewdDelegate

//Extension in order to have spaacing between profileview cell and settings/account cells
extension ProfileVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = ProfileVM(rawValue: indexPath.row) else { return }
        
        let accountVC = AccountInfoVC_empty_()
        let settingsVC = SettingsVC_empty_()
        
        switch viewModel {
        case .accountInfo: present(accountVC, animated: true, completion: nil)
        case .settings: present(settingsVC, animated: true, completion: nil)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
//MARK: - Delegates
extension ProfileVC: ProfileHeaderDelegate {
    
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileVC: ProfileFooterDelegate {
    func handleLogout() {
        delegate?.handleLogout()
    }
    
    
}
