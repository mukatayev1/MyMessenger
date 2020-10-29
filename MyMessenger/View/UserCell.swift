//
//  UserCellTableViewCell.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/26.
//

import UIKit
import SDWebImage

//A custom cell created in order to populate each cell in NewMessageVC() with profileImage, fullname and username.
class UserCell: UITableViewCell {
    
    //MARK: - Properties
    
    //this property acts as a var that will be used to populate our tableview cells with different users.
    var user: User? {
        didSet { configure() }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
//        label.text = "Username"
        label.textColor = .black
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
//        label.text = "Full name"
        return label
    }()
    
    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        subviewProfileImageView()
        subviewStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - subviews
    
    func subviewProfileImageView() {
        addSubview(profileImageView )
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(height: 56, width: 56)
        profileImageView.layer.cornerRadius = 56/2
    }
    
    func subviewStackView() {
        let stack = UIStackView(arrangedSubviews: [usernameLabel,fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
    }
    
    //MARK: - Helpers
    
    func configure() {
        //use guard let to safely unwrap the user
        guard let user = user else { return }
        
        //assigning the fullname and username of user to the labels inside of the cell.
        fullnameLabel.text = user.fullname
        usernameLabel.text = user.username
        
        //populating the cells with images
        guard let url = URL(string: user.profileImageURL) else { return }
        //the sd_setImage func fetches the url image to our project
        profileImageView.sd_setImage(with: url)
    }
    
 
    
}
 
