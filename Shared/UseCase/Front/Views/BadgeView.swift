//
//  BadgeView.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 3/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class BadgeView: UIView {
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var badgeStackViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var badgeStackViewLeadingMargin: NSLayoutConstraint!
    @IBOutlet weak var badgeStackViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var badgeStackViewTrailingMargin: NSLayoutConstraint!
    @IBOutlet weak var badgeStackView: UIStackView!
    
    @IBOutlet weak var badgeImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var badgeImageView: UIImageView!
    
    @IBOutlet weak var badgeLabel: UILabel!
    
    @IBInspectable var cornerRadius: CGFloat = .zero
    
    override var bounds: CGRect {
        didSet {
            self.roundCorners([.topRight, .bottomRight], radius: cornerRadius)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupViews()
    }
    
    fileprivate func setupViews() {
        self.loadNib()
        self.roundCorners([.topRight, .bottomRight], radius: cornerRadius)
    }
    
    private func loadNib() {
        let bundle = Bundle(for: BadgeView.self)
        let nib = UINib(nibName: String(describing: BadgeView.self), bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
        
        self.contentView.frame = .zero
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.safeTopAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.safeLeadingAnchor),
            self.safeBottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.safeTrailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
        
    func initialize(with partFragment: BadgePartFragment) {
        self.contentView.backgroundColor = partFragment.backgroundColor
        
        self.initializeBadgeImage(with: partFragment.badgeImage)
        self.initializeBadgeText(with: partFragment.badgeText)
    }
    
    func display(with partFragment: BadgePartFragment) {
        self.displayBadgeImage(with: partFragment.badgeImage)
        self.displayBadgeText(with: partFragment.badgeText)
    }
    
    func prepareViewForShow() {
        self.badgeStackViewTopMargin.constant = 8
        self.badgeStackViewLeadingMargin.constant = 18
        self.badgeStackViewBottomMargin.constant = 8
        self.badgeStackViewTrailingMargin.constant = 8
        self.badgeStackView.isHidden = false
        
        self.badgeImageView.isHidden = false
        self.badgeImageViewWidth.constant = 14
    }
    
    func prepareViewForHiding() {
        self.badgeImageView.isHidden = true
        self.badgeImageViewWidth.constant = .zero
        
        self.badgeStackView.hideView(topMargin: self.badgeStackViewTopMargin, bottomMargin: self.badgeStackViewBottomMargin, leadingMargin: self.badgeStackViewLeadingMargin, trailingMargin: self.badgeStackViewTrailingMargin, widthConstraint: nil, heightConstraint: nil)
    }
    
    fileprivate func initializeBadgeImage(with partFragment: ImagePartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            self.badgeImageView.isHidden = true
            return
        }
        
        self.badgeImageView.isHidden = false
        self.badgeImageView.backgroundColor = partFragment!.backgroundColor
        self.badgeImageView.tintColor = partFragment!.imageTintColor
    }
    
    fileprivate func initializeBadgeText(with partFragment: AttributedTextPartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            self.badgeLabel.isHidden = true
            return
        }
        
        self.badgeLabel.isHidden = false
        self.badgeLabel.backgroundColor = partFragment!.backgroundColor
    }
    
    fileprivate func displayBadgeImage(with partFragment: ImagePartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            return
        }
        
        let bundle = Bundle(for: type(of: self))
        self.badgeImageView.image = UIImage(named: partFragment!.imageUrlString, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
    
    fileprivate func displayBadgeText(with partFragment: AttributedTextPartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            return
        }
        
        self.badgeLabel.attributedText = partFragment!.attributedString
    }
}
