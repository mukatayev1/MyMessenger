//
//  Extensions.swift
//  MyMessenger
//
//  Created by AZM on 2020/10/23.
//

import UIKit
import JGProgressHUD

//Extention of the UIView in order to reuse the functions in the project.
extension UIView {
    
    //Custom constraints functions. Purpose: to make a autolayouting process faster. Example: no need to type translatesAutoresizing..., syntax is more intuitive.
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}

//Extension of VC in order to reuse the functions throughout different VC-s.
extension UIViewController {
    static let progressHud = JGProgressHUD(style: .dark)

    //a func to setup a gradient background
    func setupGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemRed.cgColor, UIColor.white.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
    //a func ot setup a "loader" whenever the screen is loading.
    func showLoader(_ show: Bool, withText text: String? = "Loading") {
        view.endEditing(true)
//        let progressHud = JGProgressHUD()
        UIViewController.progressHud.textLabel.text = text
        UIViewController.progressHud.show(in: view)
        
        if show {
            UIViewController.progressHud.show(in: view)
        } else {
            UIViewController.progressHud.dismiss(animated: true)
        }
        
    }
    
    
    // a func to setup navigation bar in various VC-s 
    func setupNavigationBar(withTitle title: String, prefersLargeTitles: Bool) {
        //creating properties for simplicity
        let appearance = UINavigationBarAppearance()
        let navBar = navigationController?.navigationBar
        
        appearance.configureWithOpaqueBackground()
        //setting a navigation bar title color to white
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .systemRed
        
        navBar?.standardAppearance = appearance
        navBar?.compactAppearance = appearance
        navBar?.scrollEdgeAppearance = appearance
        
        navBar?.prefersLargeTitles = prefersLargeTitles
        navigationItem.title = title
        navBar?.tintColor = .white
        navBar?.isTranslucent = true
        
        navBar?.overrideUserInterfaceStyle = .dark
    }
    
    func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

