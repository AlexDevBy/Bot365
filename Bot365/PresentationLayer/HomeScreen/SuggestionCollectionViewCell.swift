//
//  SuggestionCollectionViewCell.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 23.11.2022.
//

import UIKit

class SuggestionCollectionViewCell: UICollectionViewCell, ReusableView {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    var suggestionsModel: ICellShowable? {
        didSet {
            guard let model = suggestionsModel else { return }
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
        imageView.leftAnchor.constraint(equalTo: imageView.superview!.leftAnchor, constant: 16).isActive = true
        imageView.rightAnchor.constraint(equalTo: imageView.superview!.rightAnchor, constant: -16).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageView.superview!.bottomAnchor).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
}
