//
//  LoginVC.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/23.
//

import UIKit

class LoginVC: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = LoginVM()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = K.iconImage
        iv.tintColor = .white
        return iv
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
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = K.disabledButtonColor
        button.isEnabled = false
        button.setHeight(height: 50)
        button.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        tf.returnKeyType = .next
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.clearsOnBeginEditing = true
        tf.returnKeyType = .go
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Don't have an account?  ",
            attributes: [ .font: UIFont.systemFont(ofSize: 16),
                          .foregroundColor: UIColor.systemGray])
        attributedTitle.append(NSAttributedString(
                                string: "Sign Up",
                                attributes: [ .font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.systemBlue]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleDHAButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Helpers
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.systemRed
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = K.disabledButtonColor
        }
    }
    
    func setupUI() {
        view.backgroundColor = .brown
        
        let navBar = navigationController?.navigationBar
        navBar?.isHidden = true
        navBar?.barStyle = .black
        
        setupGradientLayer()
        
        //subviews
        subviewIconImage()
        subviewStackView()
        subviewDHAButton()
    }
    
    
    //MARK: - Subviewing
    
    func subviewIconImage() {
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
    }
    
    func subviewStackView() {
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        view.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 16
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 32, paddingRight: 32)
    }
    
    func subviewDHAButton() {
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    }
    
    //MARK: - Selectors
    
    @objc func handleDHAButton() {
        let controller = RegistrationVC()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleLoginButton() {
        
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = emailTextField.text
        } else {
            viewModel.password = passwordTextField.text
        }
        checkFormStatus()
    }

    
}
