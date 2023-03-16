//
//  HomeScreenView.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 23.11.2022.
//

import UIKit

class HomeScreenView: UIView {
    
    enum Constants {
        static let interItemSpacing: CGFloat = 15
    }
    
    private let suggestionTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Suggestions"
        lbl.textColor = .black
        lbl.setFont(fontName: .MontsBold, sizeXS: 18)
        return lbl
    }()
    
    private let goImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "GoLiveGoSport")
        return iv
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
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(140).dp)
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
        lbl.setFont(fontName: .MontsBold, sizeXS: 18)
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
        layout.minimumLineSpacing = Constants.interItemSpacing
        layout.minimumInteritemSpacing = 10
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
        addSubview(goImageView)
        addSubview(suggestionCollectionView)
        addSubview(pageControl)
        addSubview(suggestionTitleLabel)
        addSubview(categoriesTitleLabel)
        addSubview(categoriesCollectionView)
        addSubview(categoriesMiddleView)
        
        goImageView.topAnchor.constraint(equalTo: goImageView.superview!.topAnchor, constant: 40).isActive = true
        goImageView.leftAnchor.constraint(equalTo: goImageView.superview!.leftAnchor, constant: 16).isActive = true
        goImageView.translatesAutoresizingMaskIntoConstraints = false
        
        suggestionTitleLabel.topAnchor.constraint(equalTo: goImageView.bottomAnchor, constant: 13).isActive = true
        suggestionTitleLabel.leftAnchor.constraint(equalTo: suggestionTitleLabel.superview!.leftAnchor, constant: 16).isActive = true
        suggestionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        suggestionCollectionView.topAnchor.constraint(equalTo: suggestionTitleLabel.bottomAnchor, constant: 11).isActive = true
        suggestionCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(140).dp).isActive = true
        suggestionCollectionView.leftAnchor.constraint(equalTo: suggestionCollectionView.superview!.leftAnchor, constant: 0).isActive = true
        suggestionCollectionView.rightAnchor.constraint(equalTo: suggestionCollectionView.superview!.rightAnchor, constant: 0).isActive = true
        suggestionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.centerXAnchor.constraint(equalTo: suggestionCollectionView.centerXAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 10).isActive = true
        pageControl.topAnchor.constraint(equalTo: suggestionCollectionView.bottomAnchor, constant: 5).isActive = true
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        categoriesTitleLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20).isActive = true
        categoriesTitleLabel.leftAnchor.constraint(equalTo: categoriesTitleLabel.superview!.leftAnchor, constant: 16).isActive = true
        categoriesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoriesCollectionView.topAnchor.constraint(equalTo: categoriesTitleLabel.bottomAnchor, constant: 0).isActive = true
        categoriesCollectionView.leftAnchor.constraint(equalTo: categoriesCollectionView.superview!.leftAnchor, constant: 16).isActive = true
        categoriesCollectionView.rightAnchor.constraint(equalTo: categoriesCollectionView.superview!.rightAnchor, constant: -16).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: categoriesCollectionView.superview!.bottomAnchor).isActive = true
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        categoriesMiddleView.topAnchor.constraint(equalTo: categoriesTitleLabel.bottomAnchor).isActive = true
        categoriesMiddleView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        categoriesMiddleView.heightAnchor.constraint(equalToConstant: 13).isActive = true
        categoriesMiddleView.translatesAutoresizingMaskIntoConstraints = false
    }
}
