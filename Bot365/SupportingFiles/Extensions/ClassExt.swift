//
//  ClassExt.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit

protocol ReusableView: AnyObject {
    static var reuseID: String { get }
}

extension ReusableView where Self: UIView {
    static var reuseID: String {
        return NSStringFromClass(self)
    }
}
