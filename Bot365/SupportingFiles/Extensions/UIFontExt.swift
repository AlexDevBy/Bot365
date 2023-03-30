//
//  UIFontExt.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import ScreenType

extension UIFont {
    
    // For XS
    convenience init(font: Font, size: CGFloat) {
        self.init(name: font.rawValue, size: UIFont.getFontSizeForDifferentDevice(sizeXS: size))!
    }
    
    enum Font: String {
        case MontsRegular = "Montserrat-Regular"
        case MontsBold = "Montserrat-Bold"
        case MontsBlack = "Montserrat-Black"
        case MuseoModernoRegular = "MuseoModerno-Regular"
        case MuseoModernoMedium = "MuseoModerno-Medium"
        case MuseoModernoBold = "MuseoModerno-Bold"
        case GilroyThin = "Gilroy-Thin"
        case GilroyBold = "Gilroy-Bold"
        case GilroyMedium = "Gilroy-Medium"
        case SFProRegular = "SFPro-Regular"
        case GeneralSansMedium = "GeneralSans-Medium"
    }
    
    func printAllFonts() {
        let fontFamilyNames = UIFont.familyNames

        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")

            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }

    }
    
    static func getFontSizeForDifferentDevice(sizeXS: CGFloat) -> CGFloat {
        switch UIScreen.current {
        case .iPhone3_5:
            return sizeXS - 3
        case .iPhone4_0:
            return sizeXS - 2
        case .iPhone4_7:
            return sizeXS - 1
        case .iPhone5_5:
            return sizeXS - 1
        case .iPhone5_8: //XS
            return sizeXS
        case .iPhone6_1:
            return sizeXS
        case .iPhone6_5:
            return sizeXS + 1
        case .iPad9_7:
            return sizeXS + 3
        case .iPad10_5:
            return sizeXS + 3
        case .iPad12_9:
            return sizeXS + 3
        case .unknown:
            return sizeXS + 1
        }
    }
}
