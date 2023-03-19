//
//  CategoriesCollectionViewCell.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell, ReusableView {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    var categoriesModel: CategoriesModels? {
        didSet {
            guard let model = categoriesModel else { return }
            imageView.image = UIImage(named: model.image)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: imageView.superview!.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: imageView.superview!.leftAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: imageView.superview!.rightAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageView.superview!.bottomAnchor).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
}
