//
//  CollectionViewTextContentTheme.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

/// Theme class for text content
class CollectionViewTextContentTheme: CollectionViewContentTheme {
    
    /// Text alignment in the text container.
    fileprivate(set) var alignment: NSTextAlignment
    
    /// Line height multiple of text content. Natural height of the text(including glyph textures) by this before constraining text height by minimum and maximum line height.
    let lineHeightMultiple: CGFloat
    
    /// Minimum line height of the text.
    let minimumLineHeight: CGFloat
    
    /// Maximum line height of the text. Value of zero means no maximum line height restriction.
    let maximumLineHeight: CGFloat
    
    /// Line spacing between subsequent lines.
    let lineSpacing: CGFloat
    
    /// Head indent for first line of the text.
    let firstLineHeadIndent: CGFloat
    
    /// Head indent of the lines other than first line
    let headIndent: CGFloat
    
    /// Tail indent of the lines
    let tailIndent: CGFloat
    
    /// Boolean indicting if text should be capitalized.
    let allCaps: Bool
    
    /// Font of text.
    let font: UIFont
    
    /// Text color.
    let textColor: UIColor
    
    /// Kerning factor of Text. Value of zero means no kerning.
    let kern: NSNumber
    
    /// Underline style for text.
    let underlineStyle: NSUnderlineStyle?

    /// Underline color of text
    let underlineColor: UIColor
    
    /// Background color of text content theme.
    let backgroundColor: UIColor
    
    
    /// TextContentTheme with clear background color, zero first line head indent, zero head indent, zero tail indent and no underlining.
    /// - Parameters:
    ///   - margins: Text margins
    ///   - alignment: Text alignment
    ///   - lineHeightMultiple: Line height multiple
    ///   - minimumLineHeight: Minimum line height
    ///   - maximumLineHeight: Maximum line height
    ///   - lineSpacing: Line spacing
    ///   - allCaps: Text should be capitalized
    ///   - font: Font of text
    ///   - textColor: Text color
    ///   - kern: Kerning factor of text
    convenience init(margins: Margins,
                     alignment: NSTextAlignment,
                     lineHeightMultiple: CGFloat,
                     minimumLineHeight: CGFloat,
                     maximumLineHeight: CGFloat,
                     lineSpacing: CGFloat,
                     allCaps: Bool,
                     font: UIFont,
                     textColor: UIColor,
                     kern: NSNumber) {
        
        self.init(margins: margins,
                  alignment: alignment,
                  lineHeightMultiple: lineHeightMultiple,
                  minimumLineHeight: minimumLineHeight,
                  maximumLineHeight: maximumLineHeight,
                  lineSpacing: lineSpacing,
                  firstLineHeadIndent: .zero,
                  headIndent: .zero,
                  tailIndent: .zero,
                  allCaps: allCaps,
                  font: font,
                  textColor: textColor,
                  kern: kern,
                  underlineStyle: nil,
                  underlineColor: .clear,
                  backgroundColor: .clear)
    }
    
    /// TextContentTheme with clear background color, zero first line head indent, zero head indent and tail indent.
    /// - Parameters:
    ///   - margins: Text margins
    ///   - alignment: Text alignment
    ///   - lineHeightMultiple: Line height multiple
    ///   - minimumLineHeight: Minimum line height
    ///   - maximumLineHeight: Maximum line height
    ///   - lineSpacing: Line spacing
    ///   - allCaps: Text should be capitalized
    ///   - font: Font of text
    ///   - textColor: Text color
    ///   - kern: Kerning factor of text
    ///   - underlineStyle: Underline style of text
    ///   - underlineColor: Underline color of text
    convenience init(margins: Margins,
                     alignment: NSTextAlignment,
                     lineHeightMultiple: CGFloat,
                     minimumLineHeight: CGFloat,
                     maximumLineHeight: CGFloat,
                     lineSpacing: CGFloat,
                     allCaps: Bool,
                     font: UIFont,
                     textColor: UIColor,
                     kern: NSNumber,
                     underlineStyle: NSUnderlineStyle?,
                     underlineColor: UIColor) {
        
        self.init(margins: margins,
                  alignment: alignment,
                  lineHeightMultiple: lineHeightMultiple,
                  minimumLineHeight: minimumLineHeight,
                  maximumLineHeight: maximumLineHeight,
                  lineSpacing: lineSpacing,
                  firstLineHeadIndent: .zero,
                  headIndent: .zero,
                  tailIndent: .zero,
                  allCaps: allCaps,
                  font: font,
                  textColor: textColor,
                  kern: kern,
                  underlineStyle: underlineStyle,
                  underlineColor: underlineColor,
                  backgroundColor: .clear)
    }
    
    
    /// TextContentTheme with zero first line head indent, zero head and tail indent and no underlining.
    /// - Parameters:
    ///   - margins: Text margins
    ///   - alignment: Text alignment
    ///   - lineHeightMultiple: Line height multiple
    ///   - minimumLineHeight: Minimum line height
    ///   - maximumLineHeight: Maximum line height
    ///   - lineSpacing: Line spacing
    ///   - allCaps: Text should be capitalized
    ///   - font: Font of text
    ///   - textColor: Text color
    ///   - kern: Kerning factor of text
    ///   - backgroundColor: Background color of Text
    convenience init(margins: Margins,
                     alignment: NSTextAlignment,
                     lineHeightMultiple: CGFloat,
                     minimumLineHeight: CGFloat,
                     maximumLineHeight: CGFloat,
                     lineSpacing: CGFloat,
                     allCaps: Bool,
                     font: UIFont,
                     textColor: UIColor,
                     kern: NSNumber,
                     backgroundColor: UIColor) {
        
        self.init(margins: margins,
                  alignment: alignment,
                  lineHeightMultiple: lineHeightMultiple,
                  minimumLineHeight: minimumLineHeight,
                  maximumLineHeight: maximumLineHeight,
                  lineSpacing: lineSpacing,
                  firstLineHeadIndent: .zero,
                  headIndent: .zero,
                  tailIndent: .zero,
                  allCaps: allCaps,
                  font: font,
                  textColor: textColor,
                  kern: kern,
                  underlineStyle: nil,
                  underlineColor: .clear,
                  backgroundColor: backgroundColor)
    }

    
    /// TextContentTheme with clear background color and no underlining.
    /// - Parameters:
    ///   - margins: Text margins
    ///   - alignment: Text alignment
    ///   - lineHeightMultiple: Line height multiple
    ///   - minimumLineHeight: Minimum line height
    ///   - maximumLineHeight: Maximum line height
    ///   - lineSpacing: Line spacing
    ///   - firstLineHeadIndent: First line head indent
    ///   - headIndent: Head indent
    ///   - tailIndent: Tail indent
    ///   - allCaps: Text should be capitalized
    ///   - font: Font of text
    ///   - textColor: Text color
    ///   - kern: Kerning factor of text
    convenience init(margins: Margins,
                     alignment: NSTextAlignment,
                     lineHeightMultiple: CGFloat,
                     minimumLineHeight: CGFloat,
                     maximumLineHeight: CGFloat,
                     lineSpacing: CGFloat,
                     firstLineHeadIndent: CGFloat,
                     headIndent: CGFloat,
                     tailIndent: CGFloat,
                     allCaps: Bool,
                     font: UIFont,
                     textColor: UIColor,
                     kern: NSNumber) {
        
        self.init(margins: margins,
                  alignment: alignment,
                  lineHeightMultiple: lineHeightMultiple,
                  minimumLineHeight: minimumLineHeight,
                  maximumLineHeight: maximumLineHeight,
                  lineSpacing: lineSpacing,
                  firstLineHeadIndent: firstLineHeadIndent,
                  headIndent: headIndent,
                  tailIndent: tailIndent,
                  allCaps: allCaps,
                  font: font,
                  textColor: textColor,
                  kern: kern,
                  underlineStyle: nil,
                  underlineColor: .clear,
                  backgroundColor: .clear)
    }

    
    
    /// TextContentTheme with clear background color.
    /// - Parameters:
    ///   - margins: Text margins
    ///   - alignment: Text alignment
    ///   - lineHeightMultiple: Line height multiple
    ///   - minimumLineHeight: Minimum line height
    ///   - maximumLineHeight: Maximum line height
    ///   - lineSpacing: Line spacing
    ///   - firstLineHeadIndent: First line head indent
    ///   - headIndent: Head indent
    ///   - tailIndent: Tail indent
    ///   - allCaps: Text should be capitalized
    ///   - font: Font of text
    ///   - textColor: Text color
    ///   - kern: Kerning factor of text
    ///   - underlineStyle: Underline style of text
    ///   - underlineColor: Underline color of text
    convenience init(margins: Margins,
                     alignment: NSTextAlignment,
                     lineHeightMultiple: CGFloat,
                     minimumLineHeight: CGFloat,
                     maximumLineHeight: CGFloat,
                     lineSpacing: CGFloat,
                     firstLineHeadIndent: CGFloat,
                     headIndent: CGFloat,
                     tailIndent: CGFloat,
                     allCaps: Bool,
                     font: UIFont,
                     textColor: UIColor,
                     kern: NSNumber,
                     underlineStyle: NSUnderlineStyle?,
                     underlineColor: UIColor) {
        
        self.init(margins: margins,
                  alignment: alignment,
                  lineHeightMultiple: lineHeightMultiple,
                  minimumLineHeight: minimumLineHeight,
                  maximumLineHeight: maximumLineHeight,
                  lineSpacing: lineSpacing,
                  firstLineHeadIndent: firstLineHeadIndent,
                  headIndent: headIndent,
                  tailIndent: tailIndent,
                  allCaps: allCaps,
                  font: font,
                  textColor: textColor,
                  kern: kern,
                  underlineStyle: underlineStyle,
                  underlineColor: underlineColor,
                  backgroundColor: .clear)
    }

    
    
    /// Designated initializer for TextContentTheme.
    /// - Parameters:
    ///   - margins: Text margins
    ///   - alignment: Text alignment
    ///   - lineHeightMultiple: Line height multiple
    ///   - minimumLineHeight: Minimum line height
    ///   - maximumLineHeight: Maximum line height
    ///   - lineSpacing: Line spacing
    ///   - firstLineHeadIndent: First line head indent
    ///   - headIndent: Head indent
    ///   - tailIndent: Tail indent
    ///   - allCaps: Text should be capitalized
    ///   - font: Font of text
    ///   - textColor: Text color
    ///   - kern: Kerning factor of text
    ///   - underlineStyle: Underline style of text
    ///   - underlineColor: Underline color of text
    ///   - backgroundColor: Background color of Text
    init(margins: Margins,
         alignment: NSTextAlignment,
         lineHeightMultiple: CGFloat,
         minimumLineHeight: CGFloat,
         maximumLineHeight: CGFloat,
         lineSpacing: CGFloat,
         firstLineHeadIndent: CGFloat,
         headIndent: CGFloat,
         tailIndent: CGFloat,
         allCaps: Bool,
         font: UIFont,
         textColor: UIColor,
         kern: NSNumber,
         underlineStyle: NSUnderlineStyle?,
         underlineColor: UIColor,
         backgroundColor: UIColor) {
    
        self.alignment = alignment
        self.lineHeightMultiple = lineHeightMultiple
        self.minimumLineHeight = minimumLineHeight
        self.maximumLineHeight = maximumLineHeight
        self.lineSpacing = lineSpacing
        self.firstLineHeadIndent = firstLineHeadIndent
        self.headIndent = headIndent
        self.tailIndent = tailIndent
        self.allCaps = allCaps
        self.font = font
        self.textColor = textColor
        self.kern = kern
        self.underlineStyle = underlineStyle
        self.underlineColor = underlineColor
        self.backgroundColor = backgroundColor
                    
        super.init()

        self.margins = margins
    }
}

extension CollectionViewTextContentTheme {
    func changeAlignment(_ alignment: NSTextAlignment) {
        self.alignment = alignment
    }
}
