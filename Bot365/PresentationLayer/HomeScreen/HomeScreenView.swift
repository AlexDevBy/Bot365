//
//  HomeScreenView.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import SnapKit

class HomeScreenView: UIView {
    
    enum Constants {
        static let interItemSpacing: CGFloat = 8
    }
    
    private let suggestionTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Suggestions"
        lbl.textColor = .black
        lbl.setFont(fontName: .GilroyMedium, sizeXS: 16)
        return lbl
    }()
    
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = .lightGray
        return pageControl
    }()
    
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(164).dp)
        return layout
    }()
    
    let suggestionCollectionView: UICollectionView = {
        let layout = CarouselCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    private let categoriesTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Find in categories"
        lbl.setFont(fontName: .GilroyMedium , sizeXS: 16)
        lbl.textColor = .black
        return lbl
    }()
    
    private let categoriesMiddleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.contentInset.bottom = 150
        cv.contentInset.top = 13
        return cv
    }()
    
    private var gradientLayer = CAGradientLayer()
    private var isConfigure = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !isConfigure else { return }
        setGradientBackground()
        isConfigure.toggle()
    }
    
    private func setGradientBackground() {
        let colorBottom: CGColor = UIColor.white.withAlphaComponent(0).cgColor
        let colorTop: CGColor = UIColor.white.cgColor
        let newLayer = CAGradientLayer()
        newLayer.colors = [colorTop, colorBottom]
        newLayer.locations = [0.5, 1.0]
        newLayer.frame = CGRect(x: 0,
                                y: 0,
                                width: categoriesMiddleView.frame.width,
                                height: categoriesMiddleView.frame.height)
        gradientLayer = newLayer
        categoriesMiddleView.layer.addSublayer(gradientLayer)
    }
    
    
    private func setupView() {
        backgroundColor = .white
        addSubview(suggestionCollectionView)
        addSubview(pageControl)
        addSubview(suggestionTitleLabel)
        addSubview(categoriesTitleLabel)
        addSubview(categoriesCollectionView)
        addSubview(categoriesMiddleView)
        
        suggestionTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(68)
            make.left.equalToSuperview().offset(16)
        }
        
        suggestionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(suggestionTitleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(112)
        }


        
        pageControl.centerXAnchor.constraint(equalTo: suggestionCollectionView.centerXAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 10).isActive = true
        pageControl.topAnchor.constraint(equalTo: suggestionCollectionView.bottomAnchor, constant: 5).isActive = true
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        categoriesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
        }
        
        categoriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoriesTitleLabel.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }

        
        categoriesMiddleView.topAnchor.constraint(equalTo: categoriesTitleLabel.bottomAnchor).isActive = true
        categoriesMiddleView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        categoriesMiddleView.heightAnchor.constraint(equalToConstant: 13).isActive = true
        categoriesMiddleView.translatesAutoresizingMaskIntoConstraints = false
    }
}
