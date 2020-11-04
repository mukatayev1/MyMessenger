//
//  AccountInfoVC(empty).swift
//  MyMessenger
//
//  Created by AZM on 2020/11/04.
//

import UIKit

class AccountInfoVC_empty_: UIViewController {
    
    //MARK: - Properties
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Account Info Page"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Helpers
    
    func setupUI() {
        setupGradientLayer()
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.centerY(inView: view)
    }
    
}
