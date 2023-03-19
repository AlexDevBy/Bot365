//
//  DateExt.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit

extension Date {
    
    func toString(_ withFormat: String = "dd.MM.yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withFormat
        return dateFormatter.string(from: self)
    }
    
}
