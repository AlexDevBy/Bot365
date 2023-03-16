//
//  CGFloatExt.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 22.11.2022.
//

import UIKit

extension CGFloat {
    
    var dp: CGFloat {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            return (self / 375) * UIScreen.main.bounds.width
        } else {
            return (self / 375) * UIScreen.main.bounds.height
        }
    }
    
    var iPadDP: CGFloat {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            return (self / 769) * UIScreen.main.bounds.width
        } else {
            return (self / 769) * UIScreen.main.bounds.height
        }
    }
}
