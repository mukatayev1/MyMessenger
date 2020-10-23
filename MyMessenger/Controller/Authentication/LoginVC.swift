//
//  LoginVC.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/23.
//

import UIKit

class LoginVC: UIViewController {
    
    //MARK: - Properties
    
    private let iconImage: UIImageView = {
        let myImage = UIImageView()
        myImage.image = UIImage(systemName: "paperplane.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .black))
        myImage.tintColor = .white
        return myImage
    }()
    
    private lazy var emailContainerView: InputContainerView = {
        let cView = InputContainerView(image: K.envelopeImage!, textField: emailTextField)
        return cView
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        let cView = InputContainerView(image: K.lockImage!, textField: passwordTextField)
        return cView
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .systemPink
        button.setHeight(height: 50)
        return button
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        tf.returnKeyType = .next
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.clearsOnBeginEditing = true
        tf.returnKeyType = .go
        return tf
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - Helpers
    
    func setupUI() {
        view.backgroundColor = .brown
        
        let navBar = navigationController?.navigationBar
        navBar?.isHidden = true
        navBar?.barStyle = .black
        
        setupGradientLayer()
        
        //subviews
        subviewIconImage()
        subviewStackView()
    }
    
    func setupGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemRed.cgColor, UIColor.white.cgColor]
        gradient.locations = [0, 1]
        
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
    //MARK: - Subviewing
    
    func subviewIconImage() {
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        iconImage.setDimensions(height: 120, width: 120)
    }
    
    func subviewStackView() {
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        view.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 16
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    }
    
}
