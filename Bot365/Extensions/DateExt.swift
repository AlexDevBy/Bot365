//
//  DateExt.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 24.11.2022.
//

import UIKit

extension Date {
    
    func toString(_ withFormat: String = "dd.MM.yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withFormat
        return dateFormatter.string(from: self)
    }
    
}
