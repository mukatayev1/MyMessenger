//
//  ProfileHeader.swift
//  MyMessenger
//
//  Created by AZM on 2020/11/03.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: class {
    func dismissController()
}

class ProfileHeader: UIView {
    
    //MARK: - Properties
    
     public var user: User? {
        didSet { populateCellWithData() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(K.xMarkImage, for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.tintColor = .white
        button.setDimensions(height: 22, width: 22)
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4.0
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Mukatayev Aidos"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "@mukatayev"
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientlayer()
        backgroundColor = #colorLiteral(red: 0.2546822839, green: 0.003223826379, blue: 0.003223826379, alpha: 1)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func setupGradientlayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemRed, UIColor.white]
        gradient.locations = [0, 1]
        layer.addSublayer(gradient)
        gradient.frame = bounds
    }
    
    func setupUI() {
        profileImageView.setDimensions(height: 200, width: 200)
        profileImageView.layer.cornerRadius = 200/2
        
        addSubview(profileImageView)
        profileImageView.centerX(inView: self)
        profileImageView.anchor(top: topAnchor, paddingTop: 96)
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        stack.axis = .vertical
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.spacing = 4
        stack.anchor(top: profileImageView.bottomAnchor, paddingTop: 16)
        
        addSubview(dismissButton)
        dismissButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12)
        dismissButton.setDimensions(height: 48, width: 48)
        
    }
    
    func populateCellWithData() {
        guard let currentUser = user else {return}
        
        fullnameLabel.text = currentUser.fullname
        usernameLabel.text = "@" + currentUser.username
        
        guard let url = URL(string: currentUser.profileImageURL) else { return }
        profileImageView.sd_setImage(with: url)
        
    }
    
    //MARK: - Selectors
    
    @objc func handleDismissal() {
        delegate?.dismissController()
    }

    
}
