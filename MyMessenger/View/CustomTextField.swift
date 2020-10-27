//
//  CustomTextField.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/23.
//

import UIKit

//Custom reusable textfield  in order to reuse it in various pages without creating a messy code with too much unnecessary lines. All textfields in the app will have a common properties created in custom text field
class CustomTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 16)
        textColor = .white
        keyboardAppearance = .dark
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        layer.cornerRadius = 12
        autocorrectionType = .no
        autocapitalizationType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
