//
//  HomeModels.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 23.11.2022.
//

import Foundation

protocol ICellShowable {
    var image: String { get }
}

struct SuggestionsModels: ICellShowable {
    var image: String {
        return type.longImage
    }
    var type: SportType
}

struct CategoriesModels: ICellShowable {
    var type: SportType
    var image: String {
        return type.smallImage
    }
}
