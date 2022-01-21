//
//  ArticleSummaryTextPortionView.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 3/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class ArticleSummaryTextPortionView: UIView {
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var authorImageTopMargin: NSLayoutConstraint!
    @IBOutlet weak var authorImageLeadingMarginToKicker: NSLayoutConstraint!
    @IBOutlet weak var authorImageLeadingMarginToTitle: NSLayoutConstraint!
    @IBOutlet weak var authorImageTrailingMargin: NSLayoutConstraint!
    @IBOutlet weak var authorImageWidth: NSLayoutConstraint!
    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var kickerLeadingMargin: NSLayoutConstraint!
    @IBOutlet weak var kickerHeight: NSLayoutConstraint!
    @IBOutlet weak var kickerLabel: UILabel!
    
    @IBOutlet weak var titleTopMargin: NSLayoutConstraint!
    @IBOutlet weak var titleLeadingMargin: NSLayoutConstraint!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var leadTextTopMargin: NSLayoutConstraint!
    @IBOutlet weak var leadTextLeadingMargin: NSLayoutConstraint!
    @IBOutlet weak var leadTextWidth: NSLayoutConstraint!
    @IBOutlet weak var leadTextHeight: NSLayoutConstraint!
    @IBOutlet weak var leadTextLabel: UILabel!
    
    @IBOutlet weak var bookmarkSectionLeadingMargin: NSLayoutConstraint!
    @IBOutlet weak var bookmarkSectionTrailingMargin: NSLayoutConstraint!
    @IBOutlet weak var bookmarkSectionBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var bookmarkSectionHeight: NSLayoutConstraint!
    @IBOutlet weak var bookmarkSectionView: BookmarkSectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupViews()
    }
    
    private func setupViews() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: ArticleSummaryTextPortionView.self), bundle: bundle)
        
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
    
    fileprivate func hideAuthorImageView() {
        self.authorImageLeadingMarginToKicker.constant = .zero
        self.authorImageLeadingMarginToTitle.constant = .zero
        
        self.authorImageView.hideView(topMargin: self.authorImageTopMargin, bottomMargin: nil, leadingMargin: nil, trailingMargin: self.authorImageTrailingMargin, widthConstraint: self.authorImageWidth, heightConstraint: nil)
    }
    
    fileprivate func hideKickerLabel() {
        self.kickerLabel.hideView(topMargin: nil, bottomMargin: nil, leadingMargin: self.kickerLeadingMargin, trailingMargin: nil, widthConstraint: nil, heightConstraint: self.kickerHeight)
    }
    
    fileprivate func hideTitleLabel() {
        self.titleLabel.hideView(topMargin: self.titleTopMargin, bottomMargin: nil, leadingMargin: self.titleLeadingMargin, trailingMargin: nil, widthConstraint: nil, heightConstraint: self.titleHeight)
    }
    
    fileprivate func hideLeadText() {
        self.leadTextLabel.hideView(topMargin: self.leadTextTopMargin, bottomMargin: nil, leadingMargin: self.leadTextLeadingMargin, trailingMargin: nil, widthConstraint: self.leadTextWidth, heightConstraint: self.leadTextHeight)

    }
    
    fileprivate func hideBookmarkSection() {
        self.bookmarkSectionView.hideInternalView()
        self.bookmarkSectionView.hideView(topMargin: nil, bottomMargin: self.bookmarkSectionBottomMargin, leadingMargin: self.bookmarkSectionLeadingMargin, trailingMargin: self.bookmarkSectionTrailingMargin, widthConstraint: nil, heightConstraint: self.bookmarkSectionHeight)
    }
    
    func initializeAuthorImage(with partFragment: ImagePartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            self.hideAuthorImageView()
            return
        }
        
        self.authorImageView.isHidden = false
        self.authorImageTopMargin.constant = partFragment!.margins.top
        self.authorImageTrailingMargin.constant = partFragment!.margins.right
        self.authorImageLeadingMarginToKicker.constant = 10
        self.authorImageLeadingMarginToTitle.constant = 10
        
        self.authorImageWidth.constant = partFragment!.size.width
        self.authorImageView.layer.masksToBounds = true
        self.authorImageView.layer.cornerRadius = partFragment!.size.width / 2
        self.authorImageView.layer.borderWidth = 2
        self.authorImageView.layer.borderColor = UIColor.shadesOfBlue03().cgColor
        
        self.authorImageView.backgroundColor = partFragment!.backgroundColor
    }
    
    func initializeKicker(with partFragment: AttributedTextPartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            self.hideKickerLabel()
            return
        }
        
        self.configureText(with: partFragment!, for: self.kickerLabel, labelWidth: nil, labelHeight: self.kickerHeight, topMargin: nil, leadingMargin: self.kickerLeadingMargin, trailingMargin: nil)
    }
    
    func initializeTitle(with partFragment: AttributedTextPartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            self.hideTitleLabel()
            return
        }
        
        self.configureText(with: partFragment!, for: self.titleLabel, labelWidth: nil, labelHeight: self.titleHeight, topMargin: self.titleTopMargin, leadingMargin: self.titleLeadingMargin, trailingMargin: nil)
    }
    
    func initializeLeadText(with partFragment: AttributedTextPartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            self.hideLeadText()
            return
        }
        
        self.configureText(with: partFragment!, for: self.leadTextLabel, labelWidth: self.leadTextWidth, labelHeight: self.leadTextHeight, topMargin: self.leadTextTopMargin, leadingMargin: self.leadTextLeadingMargin, trailingMargin: nil)
    }
    
    fileprivate func configureText(with partFragment: AttributedTextPartFragment, for label: UILabel, labelWidth: NSLayoutConstraint?, labelHeight: NSLayoutConstraint, topMargin: NSLayoutConstraint?, leadingMargin: NSLayoutConstraint, trailingMargin: NSLayoutConstraint?) {
        label.isHidden = false
        labelWidth?.constant = partFragment.size.width
        labelHeight.constant = partFragment.size.height
        topMargin?.constant = partFragment.margins.top
        leadingMargin.constant = partFragment.margins.left
        trailingMargin?.constant = partFragment.margins.right
        label.backgroundColor = partFragment.backgroundColor
    }
    
//    func initializeBookmarkSection(with partFragment: BookmarkSectionPartFragment?) {
//        guard !(partFragment?.isEmpty() ?? true) else {
//            self.hideBookmarkSection()
//            return
//        }
//
//        self.bookmarkSectionView.isHidden = false
//        self.bookmarkSectionHeight.constant = partFragment!.size.height
//        self.bookmarkSectionLeadingMargin.constant = partFragment!.margins.left
//        self.bookmarkSectionTrailingMargin.constant = partFragment!.margins.right
//        self.bookmarkSectionBottomMargin.constant = partFragment!.margins.bottom
//        self.bookmarkSectionView.initialize(with: partFragment!)
//    }
//
//    func setBookmarkSectionViewDelegate(_ viewDelegate: BookmarkSectionViewDelegate?) {
//        self.bookmarkSectionView.viewDelegate = viewDelegate
//    }
    
    func bookmarkStatusChanged(added: Bool) {
        self.bookmarkSectionView.bookmarkStatusChanged(added: added)
    }
    
    func displayAuthorImage(with partFragment: ImagePartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            return
        }
        
        if let imageUrl = URL(string: partFragment!.imageUrlString) {
//            self.authorImageView.sd_setImage(with: imageUrl, completed: nil)
        }
    }
    
    func displayKicker(with partFragment: AttributedTextPartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            return
        }

        self.kickerLabel.display(attrString: partFragment!.attributedString, updatingLineBreakModeWith: .byTruncatingTail)
    }
    
    func displayTitle(with partFragment: AttributedTextPartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            return
        }

        self.titleLabel.display(attrString: partFragment!.attributedString, updatingLineBreakModeWith: .byTruncatingTail)
    }
    
    func displayLeadText(with partFragment: AttributedTextPartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            return
        }

        self.leadTextLabel.display(attrString: partFragment!.attributedString, updatingLineBreakModeWith: .byTruncatingTail)
    }
    
//    func displayBookmarkSection(with partFragment: BookmarkSectionPartFragment?) {
//        guard !(partFragment?.isEmpty() ?? true) else {
//            return
//        }
//    
//        self.bookmarkSectionView.display(with: partFragment!)
//    }
}
