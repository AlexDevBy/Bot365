//
//  CustomTabBar.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit

protocol CustomTabBarDelegate: AnyObject {
    func itemWasTapped(with index: Int)
}

final class CustomTabBar: UIStackView {
    
    // MARK: - Public properties
    var itemTapped: Int = 0
    var allViewControllers: [UIViewController] {
        customItemViews.map(\.viewController)
    }
    weak var delegate: CustomTabBarDelegate?
    
    // MARK: - Private Properties
    private lazy var customItemViews: [CustomItemView] = [homeItem,
                                                          calendarItem,
                                                          settingsItem]
    private lazy var homeItem = CustomItemView(with: CustomTabItem(type: .home,
                                                                   viewController: CustomNavigationController(rootViewController: presentationAssemmbly.homeScreen())
                                                                  ),
                                               index: 0)
    private lazy var calendarItem = CustomItemView(with: CustomTabItem(type: .calendar,
                                                                       viewController: CustomNavigationController(rootViewController:  presentationAssemmbly.calendarScreen())
                                                                      ),
                                                        index: 1)
    private lazy var settingsItem = CustomItemView(with: CustomTabItem(type: .settings,
                                                                       viewController: CustomNavigationController(rootViewController: presentationAssemmbly.settingsScreen())
                                                                      ),
                                                   index: 2)
    private let presentationAssemmbly: IPresentationAssembly
    
    init(presentationAssembly: IPresentationAssembly) {
        self.presentationAssemmbly = presentationAssembly
        super.init(frame: .zero)
        setupHierarchy()
        setupProperties()
        setNeedsLayout()
        layoutIfNeeded()
        selectItem(index: 0)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addArrangedSubview(homeItem)
        addArrangedSubview(calendarItem)
        addArrangedSubview(settingsItem)
    }
    
    private func setupProperties() {
        backgroundColor = UIColor.AppCollors.tabBar
        addBackground(color: UIColor.AppCollors.tabBar, cornerRadius: 20)
        distribution = .fillEqually
        alignment = .center
        layer.cornerRadius = 25        
        customItemViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
            $0.viewTapped = selectItem
        }
    }
    
    func getIndexFor(type: CustomTabItemType) -> Int? {
        customItemViews.first { $0.type == type }?.index
    }
    
    func selectItem(index: Int) {
        customItemViews.forEach { $0.isSelected = $0.index == index }
        delegate?.itemWasTapped(with: index)
    }
}

private extension UIStackView {
    func addBackground(color: UIColor, cornerRadius: CGFloat = 0) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.layer.cornerRadius = cornerRadius
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }
}
