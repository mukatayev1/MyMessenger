//
//  RegistrationVC.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/23.
//

import UIKit

class RegistrationVC: UIViewController {

    //MARK: - Properties
    
    var viewModel = RegistrationVM()

    let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(K.addImage, for: .normal)
        button.setTitle("Add Photo", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private lazy var emailContainerView: InputContainerView = {
        let cView = InputContainerView(image: K.envelopeImage!, textField: emailTextField)
        return cView
    }()
    
    private lazy var fullNameContainerView: InputContainerView = {
        let cView = InputContainerView(image: K.userImage!, textField: fullNameTextField)
        return cView
    }()
    
    private lazy var usernameContainerView: InputContainerView = {
        let cView = InputContainerView(image: K.userImage!, textField: usernameTextField)
        return cView
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        let cView = InputContainerView(image: K.lockImage!, textField: passwordTextField)
        return cView
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        tf.returnKeyType = .next
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Full Name")
        tf.returnKeyType = .next
        tf.autocapitalizationType = .words
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private let usernameTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Username")
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
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = K.disabledButtonColor
        button.isEnabled = false
        button.setHeight(height: 50)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Already have an account?  ",
            attributes: [ .font: UIFont.systemFont(ofSize: 16),
                          .foregroundColor: UIColor.systemGray])
        attributedTitle.append(NSAttributedString(
                                string: "Log in",
                                attributes: [ .font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.systemBlue]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleAHAButton), for: .touchUpInside)
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
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.systemRed
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = K.disabledButtonColor
        }
    }
    
    func setupUI() {
        
        setupGradientLayer()
        
        //subviews
        subviewAddImageButton()
        subviewStackView()
        subviewAHAButtonButton()
    }
    
    //func to move up
//    func configureNotificationObservers() {
//        
//    }
    
    //MARK: - Subviewing
    
    func subviewAddImageButton() {
        view.addSubview(addImageButton)
        addImageButton.centerX(inView: view)
        addImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        addImageButton.setDimensions(height: 170, width: 170)
    }
    
    func subviewStackView() {
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   fullNameContainerView,
                                                   usernameContainerView,
                                                   passwordContainerView,
                                                   signUpButton])
        view.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 16
        stack.anchor(top: addImageButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    }
    
    func subviewAHAButtonButton() {
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    }
    
    //MARK: - Selectors
    
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    @objc func handleAHAButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = emailTextField.text
        } else if sender == passwordTextField {
            viewModel.password = passwordTextField.text
        } else if sender == fullNameTextField {
            viewModel.fullname = fullNameTextField.text
        } else if sender == usernameTextField {
            viewModel.username = usernameTextField.text
        }
        
        checkFormStatus()
    }
}

//MARK: - Extension

extension RegistrationVC: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        addImageButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        addImageButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        addImageButton.layer.borderWidth = 3.0
        addImageButton.layer.cornerRadius = 170/2
        
        dismiss(animated: true, completion: nil)
    }
    
}
