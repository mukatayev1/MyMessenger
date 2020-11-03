//
//  ConversationCell.swift
//  MyMessenger
//
//  Created by AZM on 2020/11/03.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    //MARK: - Properties
    
    var conversation: Conversation? {
        didSet { configure() }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = "2h"
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        subviewElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let conversation = conversation else {return}
        let viewModel = ConversationVM(conversation: conversation)
        
        usernameLabel.text = conversation.user.username
        messageLabel.text = conversation.message.text
        
        timeStampLabel.text = viewModel.timestamp
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
    }
    
    func subviewElements() {
        //profileImageView
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(height: 50, width: 50)
        profileImageView.layer.cornerRadius = 50/2
        profileImageView.centerY(inView: self)
        
        //stack of username and message labels
        let stack = UIStackView(arrangedSubviews: [usernameLabel, messageLabel])
        stack.spacing = 4
        
        addSubview(stack)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
        stack.axis = .vertical
        stack.centerY(inView: profileImageView)
        
        //Timestamp
        addSubview(timeStampLabel)
        timeStampLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 12)
    }
}
