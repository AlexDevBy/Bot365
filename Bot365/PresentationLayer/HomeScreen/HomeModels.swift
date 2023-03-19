//
//  HomeModels.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
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
