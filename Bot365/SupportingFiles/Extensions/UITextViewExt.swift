//
//  UITextViewExt.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit

extension UITextView {
    func addHyperLinksToText(originalText: String, hyperLinks: [String: String], font: UIFont, textAlignment: NSTextAlignment = .center) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
        for (hyperLink, urlString) in hyperLinks {
            let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
            attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: linkRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: font, range: fullRange)
        }
        attributedOriginalText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: fullRange)
        return attributedOriginalText
    }
}
