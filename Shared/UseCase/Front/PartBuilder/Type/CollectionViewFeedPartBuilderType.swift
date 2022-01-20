//
//  CollectionViewFeedPartBuilderType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewFeedPartBuilderType: FeedPartBuilderType {
    associatedtype SectionType
    
    var pageType: PageType { get }
    
    func getFeedMappingContext() -> FeedMappingContextType
    func getInitials(section: SectionType, scrollDirection: UICollectionView.ScrollDirection) -> CollectionViewSectionLayoutInitialsDefinerType
    func getSectionType(for component: Component) -> SectionType
    func isSectionTypeEqual(lhs: SectionType, rhs: SectionType) -> Bool
    func buildHeaderPart(forSection section: SectionType) -> CollectionViewFeedPart?
}

extension CollectionViewFeedPartBuilderType {
    func normalizeHeights(parts: [CollectionViewFeedPart], maxHeight: CGFloat) -> [CGFloat] {
        var neededHeight: CGFloat = .zero
        
        var contentHeights = [CGFloat] ()
        
        for part in parts {
            neededHeight = maxHeight - part.size.height
            part.size.height += neededHeight
            contentHeights.append(part.size.height)
        }
        
        return contentHeights
    }
    
    func sectionizeComponents(components: [Component]) -> [IntermediaryPart<SectionType>]{
        guard !components.isEmpty else {
            return []
        }
        
        var section = [IntermediaryPart<SectionType>] ()
        
        var previousType = self.getSectionType(for: components[components.startIndex])
        var currentType = previousType
        var sectionComponents = [components[components.startIndex]]
                              
        for index in 1..<components.endIndex {
            let currentComponent = components[index]
            currentType = self.getSectionType(for: currentComponent)
            
            if !self.isSectionTypeEqual(lhs: currentType, rhs: previousType) {
                section.append(IntermediaryPart<SectionType>(section: previousType, components: sectionComponents))
                sectionComponents = []
                previousType = currentType
            }
            
            sectionComponents.append(components[index])
        }
        
        section.append(IntermediaryPart<SectionType>(section: previousType, components: sectionComponents))
        
        return section
    }
    
    func buildUpParts(components: [Component], bounds: CGSize, scrollDirection: UICollectionView.ScrollDirection) -> [CollectionViewSectionInfoProviding] {
        let sections = self.sectionizeComponents(components: components)
        
        guard !sections.isEmpty else {
            return []
        }
        
        var sectionParts = [CollectionViewSectionInfoProviding] ()
        let mappingContext = self.getFeedMappingContext()
        
        var maxHeight: CGFloat = .zero
        var parts = [CollectionViewFeedPart] ()
        var contentHeights = [CGFloat] ()
        
        for section in sections {
            let sectionInitials = self.getInitials(section: section.section, scrollDirection: scrollDirection)
            
            let headerPart = self.buildHeaderPart(forSection: section.section)
            sectionInitials.getSupplimentaryViewProvidder().setHeaderPart(headerPart)
            
            sectionInitials.prepare(with: bounds, for: scrollDirection)
            
            mappingContext.changePreviousPart(.top)
            
            mappingContext.changeContentWidth(width: sectionInitials.getItemWidth())
            
            maxHeight = .zero
            parts = []
            contentHeights = []
            
            var isFirstComponent = false
            var isLastComponent = false
                        
            for index in 0..<section.components.count {
                isFirstComponent = index == 0
                isLastComponent = index == section.components.count - 1
                
               let part = self.buildUpPart(for: section.components[index], isFirstComponentInSection: isFirstComponent, isLastComponentInSection: isLastComponent, context: mappingContext)
                
                if !(part is UnknownPart) && part.size != .zero {
                    parts.append(part)
                    contentHeights.append(part.size.height)
                    if maxHeight < part.size.height {
                        maxHeight = part.size.height
                    }
                }
            }
            
            if sectionInitials.hasSameHeightCell() {
                contentHeights = self.normalizeHeights(parts: parts, maxHeight: maxHeight)
            }
            
            sectionInitials.finalise(contentHeights: contentHeights)
            
            if parts.count > 0 {
                sectionParts.append(SectionPart(sectionInitalsDefiner: sectionInitials, parts: parts))
            }
        }
        
        return sectionParts
    }
    
    
}

extension CollectionViewFeedPartBuilderType {
    func getNeededWidth(for partFragment: PartFragment) -> CGFloat {
        return partFragment.margins.left + partFragment.size.width + partFragment.margins.right
    }
    
    func getNeededHeight(for partFragment: PartFragment) -> CGFloat {
        return partFragment.margins.top + partFragment.size.height + partFragment.margins.bottom
    }
    
    func getPerformanceEfficientBackgroundColor(desiredBackgroundColor: UIColor, fallbackBackgroundColor: UIColor) -> UIColor {
        return desiredBackgroundColor == .clear ? fallbackBackgroundColor : desiredBackgroundColor
    }
    
    
}

extension CollectionViewFeedPartBuilderType {
    func mapAttributesOfText(theme: CollectionViewTextContentTheme, shouldUseHyphenation: Bool) -> [NSAttributedString.Key : Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = theme.alignment
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.paragraphSpacingBefore = .zero
        paragraphStyle.lineHeightMultiple = theme.lineHeightMultiple
        paragraphStyle.minimumLineHeight = theme.minimumLineHeight
        paragraphStyle.maximumLineHeight = theme.maximumLineHeight
        paragraphStyle.firstLineHeadIndent = theme.firstLineHeadIndent
        paragraphStyle.headIndent = theme.headIndent
        paragraphStyle.tailIndent = theme.tailIndent
        paragraphStyle.lineSpacing = theme.lineSpacing
        
        if shouldUseHyphenation {
            paragraphStyle.hyphenationFactor = 1.0
        }
        
        var attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : theme.font,
                          NSAttributedString.Key.foregroundColor: theme.textColor,
                          NSAttributedString.Key.backgroundColor: theme.backgroundColor,
                          NSAttributedString.Key.kern : theme.kern,
                          NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        if let underlineStyle = theme.underlineStyle {
            attributes[NSAttributedString.Key.underlineStyle] = underlineStyle.rawValue
            attributes[NSAttributedString.Key.underlineColor] = theme.underlineColor
        }
        
        return attributes
    }
    
    func mapAttributedText(text: String, theme: CollectionViewTextContentTheme, shouldUseHyphenation: Bool) -> NSAttributedString {
        let factorizedText = theme.allCaps ? text.uppercased() : text
        
        return NSAttributedString(string: factorizedText, attributes: self.mapAttributesOfText(theme: theme, shouldUseHyphenation: shouldUseHyphenation))
    }
}

extension CollectionViewFeedPartBuilderType {
    func selectImageUrlForResolution(_ image: Image, contentWidth: CGFloat, heightRatio: CGFloat = 0) -> (urlString: String, height: CGFloat) {
        guard image.descriptors.count != 0 else {
            return (urlString: "", height: .zero)
        }

        let expectedWidth = contentWidth
        let descriptor = selectImageDescriptorByPixel(image.descriptors, expectedWidth: expectedWidth)
        let scale = expectedWidth / descriptor.size.width
        let scaledHeight = ceil(descriptor.size.height * scale)
        
        return (urlString: descriptor.urlString, height: scaledHeight)
    }
    
    func selectImageDescriptorByPixel(_ imageDescriptors: [ImageDescriptor], gapPoints: CGFloat, contentWidth: CGFloat) -> ImageDescriptor {
        return self.selectImageDescriptorByPixel(imageDescriptors, expectedWidth: contentWidth - gapPoints)
    }
    
    func selectImageDescriptorByPixel(_ imageDescriptors: [ImageDescriptor], expectedWidth: CGFloat) -> ImageDescriptor {
        guard !imageDescriptors.isEmpty else {
            return ImageDescriptor.emptyDescriptor
        }

        let expectedWidthInPixel = expectedWidth * UIScreen.main.scale
        let descriptor = imageDescriptors.filter({ descriptor in return descriptor.size.width == expectedWidthInPixel })
        if descriptor.count != 0 {
            return descriptor[0]
        }

        let diffs = imageDescriptors.map({descriptor in return abs(descriptor.size.width - expectedWidthInPixel)})
        if let minDiffIndex = diffs.firstIndex(of: diffs.min()!) , diffs.count != 0 {
            return imageDescriptors[minDiffIndex]
        }

        return imageDescriptors[0]
    }
}

extension CollectionViewFeedPartBuilderType {
    func calculateRemainingSpace(initialSpace: CGFloat, occupiedSpace: CGFloat) -> CGFloat {
        guard initialSpace != .greatestFiniteMagnitude else {
            return .greatestFiniteMagnitude
        }
        
        let diff = initialSpace - occupiedSpace
        return diff > .zero ? diff : .zero
    }
    
    func getNeededWidth(partFragment: PartFragment?) -> CGFloat {
        return partFragment != nil ? self.getNeededWidth(for: partFragment!) : .zero
    }
    
    func getNeededHeight(partFragment: PartFragment?) -> CGFloat {
        return partFragment != nil ? self.getNeededHeight(for: partFragment!) : .zero
    }
}
