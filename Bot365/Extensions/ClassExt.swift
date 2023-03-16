//
//  ClassExt.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 23.11.2022.
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
