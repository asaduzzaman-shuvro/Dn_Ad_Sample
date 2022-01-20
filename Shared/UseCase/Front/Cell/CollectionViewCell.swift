//
//  CollectionViewCell.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, CollectionViewPartDisplaying, CollectionViewCellReusing {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupViews()
    }
        
    func setupViews() {}
    
    func initializeView(with part: CollectionViewFeedPart) {
        if part.topRounding || part.bottomRounding {
            var rectCorners = UIRectCorner()
            
            if  part.topRounding {
                if part.bottomRounding {
                    rectCorners = UIRectCorner([.allCorners])
                }else {
                    rectCorners = UIRectCorner([.topLeft, .topRight])
                }
            }else if part.bottomRounding {
                rectCorners = UIRectCorner([.bottomLeft, .bottomRight])
            }
            
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCorners, cornerRadii: CGSize(width: 4, height: 4))
            
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.contentView.layer.masksToBounds = true
            self.contentView.layer.mask = maskLayer
        }
        
        self.changeContentViewBackgroundColor(part.backgroundColor)
    }
    
    func changeContentViewBackgroundColor(_ color: UIColor) {
        self.contentView.backgroundColor = color
    }
    
    func displayPart(_ part: CollectionViewFeedPart) {}
    
}


class CollectionViewVideoCell: CollectionViewCell, CollectionViewVideoPartDisplaying {
    func attachPlayerToView() {
        
    }
    
    func removePlayerFromView() {
        
    }
    
}
