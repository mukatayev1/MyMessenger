//
//  InputContainerView.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/23.
//

import UIKit

//Custom reusable container view for textfields in order to reuse it in various pages without creating a messy code with too much unnecessary lines
class InputContainerView: UIView {
    
    init(image: UIImage, textField: UITextField) {
        super.init(frame: .zero)
        
        setHeight(height: 50)
        
        let iv = UIImageView()
        iv.image = image
        iv.tintColor = .white
        iv.alpha = 0.8
        
        addSubview(iv)
        iv.centerY(inView: self)
        iv.anchor(left: leftAnchor, paddingLeft: 8)
        iv.setDimensions(height: 30, width: 30)
        
        addSubview(textField)
        textField.centerY(inView: self)
        textField.anchor(left: iv.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8, paddingBottom: -8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        addSubview(dividerView)
        dividerView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8, height: 0.75)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
