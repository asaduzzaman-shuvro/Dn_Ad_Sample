//
//  ImagePartFragment.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class ImagePartFragment: PartFragment {
    let imageUrlString: String
    fileprivate (set) var imageTintColor: UIColor?
    
    convenience init(imageUrlString: String, size: CGSize, margins: Margins, backgroundColor: UIColor) {
        self.init(imageUrlString: imageUrlString, imageTintColor: nil, size: size, margins: margins, backgroundColor: backgroundColor)
    }
    
    init(imageUrlString: String, imageTintColor: UIColor?, size: CGSize, margins: Margins, backgroundColor: UIColor) {
        self.imageUrlString = imageUrlString
        self.imageTintColor = imageTintColor
        
        super.init()
        
        self.size = size
        self.margins = margins
        self.backgroundColor = backgroundColor
    }
    
    func changeImageTintColor(with color: UIColor) {
        self.imageTintColor = color
    }
    
    override func isEmpty() -> Bool {
        if super.isEmpty() || self.imageUrlString.isEmpty {
            return true
        }
        
        return false
    }
}
