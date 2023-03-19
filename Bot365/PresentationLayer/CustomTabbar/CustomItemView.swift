//
//  CustomItemView.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit

final class CustomItemView: UIView {
    
    // MARK: Public
    var viewTapped: ((Int) -> Void)?
    var viewController: UIViewController { item.viewController }
    var type: CustomTabItemType { item.type }
    let index: Int
    var isSelected = false {
        didSet {
            animateItems()
        }
    }
    
    // MARK: - Privates
    private let buttonOver = UIButton()
    private let iconImageView = UIImageView()
    private let containerView = UIView()
    private let item: CustomTabItem

    init(with item: CustomTabItem, index: Int) {
        self.item = item
        self.index = index
        super.init(frame: .zero)
        
        setupHierarchy()
        setupLayout()
        setupProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(buttonOver)
    }
    
    private func setupLayout() {
        containerView.topAnchor.constraint(equalTo: containerView.superview!.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: containerView.superview!.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: containerView.superview!.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: containerView.superview!.bottomAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: containerView.superview!.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: containerView.superview!.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        containerView.translatesAutoresizingMaskIntoConstraints = false

        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: iconImageView.superview!.centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: iconImageView.superview!.centerYAnchor).isActive = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonOver.topAnchor.constraint(equalTo: buttonOver.superview!.topAnchor).isActive = true
        buttonOver.leftAnchor.constraint(equalTo: buttonOver.superview!.leftAnchor).isActive = true
        buttonOver.rightAnchor.constraint(equalTo: buttonOver.superview!.rightAnchor).isActive = true
        buttonOver.bottomAnchor.constraint(equalTo: buttonOver.superview!.bottomAnchor).isActive = true
        buttonOver.translatesAutoresizingMaskIntoConstraints = false
        buttonOver.addTarget(self, action: #selector(tabTapped), for: .touchUpInside)
     }
    
    private func setupProperties() {
        iconImageView.image = isSelected ? item.selectedIcon : item.icon
    }
    
    private func animateItems() {
         UIView.transition(with: iconImageView,
                           duration: 0.4,
                           options: .transitionCrossDissolve) { [unowned self] in
             self.iconImageView.image = self.isSelected ? self.item.selectedIcon : self.item.icon
         }
     }
    
    @objc
    private func tabTapped() {
        viewTapped?(index)
    }
}
