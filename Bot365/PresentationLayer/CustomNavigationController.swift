//
//  CustomNavigationController.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 23.11.2022.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = UIColor.AppCollors.yeallow
        navigationBar.backItem?.title = ""
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(font: .MontsBlack, size: 16)
        ]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addGoBackButton()
    }
    
    private func addGoBackButton() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ArrowLeft")?.withRenderingMode(.alwaysOriginal), for: .normal)
        //            button.setTitle("Back", for: .normal)
        //            button.sizeToFit()
        button.tintColor = .yellow
//        navigationBar.backItem = UIBarButtonItem(customView: button)
//        navigationItem.backBarButtonItem = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    @objc
    private func goBack() {
        dismiss(animated: true)
    }

}
