//
//  CustomInputAccessoryView.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/28.
//

import UIKit

class CustomInputAccessoryView: UIView {
    
    //MARK: - Properties
    
    private let messageInputView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.cornerRadius = 18
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(K.circleArrowUpImage, for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
        return button
    }()
    
    private var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter message..."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9572493655, green: 0.9572493655, blue: 0.9572493655, alpha: 1)
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
        autoresizingMask = .flexibleHeight
        
        addSubview(sendButton)
        sendButton.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingBottom: 5, paddingRight: 5)
        sendButton.setDimensions(height: 50, width: 50)
        
        addSubview(messageInputView)
        messageInputView.anchor(top: topAnchor,
                                left: leftAnchor,
                                bottom: safeAreaLayoutGuide.bottomAnchor,
                                right: sendButton.leftAnchor,
                                paddingTop: 10,
                                paddingLeft: 13, paddingBottom: 10, paddingRight: 3)
        
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(left: messageInputView.leftAnchor, paddingLeft: 4)
        placeHolderLabel.centerY(inView: messageInputView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    //MARK: - Selectors
    
    @objc func handleSendButton() {
        print("Handle send message")
    }
    
    @objc func handleTextInputChange() {
        placeHolderLabel.isHidden = !self.messageInputView.text.isEmpty
    }
    
}
