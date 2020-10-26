//
//  RegistrationVC.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/23.
//

import UIKit
import Firebase

class RegistrationVC: UIViewController {
    
    //MARK: - Properties
    
    var viewModel = RegistrationVM()
    var profileImage: UIImage?
    
    let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(K.plusCircleImage, for: .normal)
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
        
        return tf
    }()
    
    private let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Full Name")
        tf.returnKeyType = .next
        tf.autocapitalizationType = .words
        
        return tf
    }()
    
    private let usernameTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Username")
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
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = K.disabledButtonColor
        button.isEnabled = false
        button.setHeight(height: 50)
        button.addTarget(self, action: #selector(handleSignupButton), for: .touchUpInside)
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
        configureNotificationObservers()
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
    
    //func to move up the keyboard
    func configureNotificationObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
    }
    
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
    
    @objc func handleSignupButton() {
        guard let email = emailTextField.text else {return}
        guard let fullname = fullNameTextField.text else {return}
        guard let username = usernameTextField.text?.lowercased() else {return}
        guard let password = passwordTextField.text else {return}
        guard let profileImage = profileImage else {return}
        
        let credentials = RegistrationCredentials(email: email, fullname: fullname, username: username, password: password, profileImage: profileImage)
        
        showLoader(true, withText: "Signing up")
        
        AuthService.shared.createUser(credentials: credentials) { (error) in
            if let error = error {
                print("DEBUG: error: \(error)")
                self.showLoader(false)
                return
            }
            self.showLoader(false)
            self.dismiss(animated: true, completion: nil)
        }
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
    
    //Notification center functions "Keyboard will show" & "Keyboard will hide"
    @objc func keyboardWillShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

//MARK: - Extension

extension RegistrationVC: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        //setting the image to profileImage
        profileImage = image
        addImageButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        addImageButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        addImageButton.layer.borderWidth = 3.0
        addImageButton.layer.cornerRadius = 170/2
        
        dismiss(animated: true, completion: nil)
    }
    
}
