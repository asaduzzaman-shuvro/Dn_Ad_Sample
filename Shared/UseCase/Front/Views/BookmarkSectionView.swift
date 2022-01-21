//
//  BookmarkSectionView.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 3/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class BookmarkSectionView: UIView {    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var headerLabelTrailingMargin: NSLayoutConstraint!
    @IBOutlet weak var headerLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var headerLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var skinImageTrailingMargin: NSLayoutConstraint!
    @IBOutlet weak var skinImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var skinImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var skinImageView: UIImageView!
    
    @IBOutlet weak var bookmarkImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var bookmarkImageView: UIImageView!
    
//    weak var viewDelegate: BookmarkSectionViewDelegate?
//
//    fileprivate var partFragment: BookmarkSectionPartFragment!
    fileprivate var isBookmarkedItemSectionView: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupViews()
    }
    
    private func setupViews() {
        let bundle = Bundle(for: BookmarkSectionView.self)
        let nib = UINib(nibName: String(describing: BookmarkSectionView.self), bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
        
        contentView.frame = .zero
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.safeTopAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.safeLeadingAnchor),
            self.safeBottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.safeTrailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let headerTapGestureRecognizer = UITapGestureRecognizer()
        headerTapGestureRecognizer.addTarget(self, action: #selector(BookmarkSectionView.headerLabelTapped(_:)))
        self.headerLabel.addGestureRecognizer(headerTapGestureRecognizer)
        
        let bookmarkImageTapGestureRecognizer = UITapGestureRecognizer()
        bookmarkImageTapGestureRecognizer.addTarget(self, action: #selector(BookmarkSectionView.bookmarkIconTapped(_:)))
        self.bookmarkImageView.addGestureRecognizer(bookmarkImageTapGestureRecognizer)
    }
    
    func hideInternalView() {
        self.hideHeaderLabel()
        self.hideSkinImage()
        self.hideBookmarkImage()
    }
    
    fileprivate func hideSkinImage() {
        self.skinImageView.hideView(topMargin: nil, bottomMargin: nil, leadingMargin: nil, trailingMargin: self.skinImageTrailingMargin, widthConstraint: self.skinImageViewWidth, heightConstraint: self.skinImageViewHeight)
    }
    
    fileprivate func hideBookmarkImage() {
        self.bookmarkImageView.hideView(topMargin: nil, bottomMargin: nil, leadingMargin: nil, trailingMargin: nil, widthConstraint: self.bookmarkImageViewWidth, heightConstraint: nil)
    }
    
    fileprivate func hideHeaderLabel() {
        self.headerLabel.hideView(topMargin: nil, bottomMargin: nil, leadingMargin: nil, trailingMargin: self.headerLabelTrailingMargin, widthConstraint: self.headerLabelWidth, heightConstraint: self.headerLabelHeight)
    }
    
//    func initialize(with partFragment: BookmarkSectionPartFragment) {
//        self.backgroundColor = partFragment.backgroundColor
//        self.contentView.backgroundColor = partFragment.backgroundColor
//
//        self.initializeHeaderText(with: partFragment.headerText)
//        self.initializeSkinImage(with: partFragment.skinImage)
//    }
//
//    func display(with partFragment: BookmarkSectionPartFragment) {
//        self.partFragment = partFragment
//
//        self.displayHeaderText(with: partFragment.headerText)
//        self.displaySkinImage(with: partFragment.skinImage)
//        self.setupBookmarkImagePartFragment()
//    }
    
    fileprivate func initializeHeaderText(with partFragment: AttributedTextPartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            self.hideHeaderLabel()
            return
        }
        
        self.headerLabel.isHidden = false
        self.headerLabelTrailingMargin.constant = partFragment!.margins.right
        self.headerLabelWidth.constant = partFragment!.size.width
        self.headerLabelHeight.constant = partFragment!.size.height
        self.headerLabel.backgroundColor = partFragment!.backgroundColor
    }
    
    fileprivate func initializeSkinImage(with partFragment: ImagePartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            self.hideSkinImage()
            return
        }
        
        self.skinImageView.isHidden = false
        self.skinImageTrailingMargin.constant = partFragment!.margins.right
        self.skinImageViewWidth.constant = partFragment!.size.width
        self.skinImageViewHeight.constant = partFragment!.size.height
        
        self.skinImageView.backgroundColor = partFragment!.backgroundColor
        self.skinImageView.tintColor = partFragment!.imageTintColor
    }
    
    fileprivate func initializeBookmarkImage(with partFragment: ImagePartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            self.hideBookmarkImage()
            return
        }
        
        self.bookmarkImageView.isHidden = false
        self.bookmarkImageViewWidth.constant = partFragment!.size.width
        self.bookmarkImageView.backgroundColor = partFragment!.backgroundColor
        self.bookmarkImageView.tintColor = partFragment!.imageTintColor
    }
    
    fileprivate func displayHeaderText(with partFragment: AttributedTextPartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            return
        }
        
//        self.headerLabel.display(attrString: partFragment!.attributedString, updatingLineBreakModeWith: .byTruncatingTail)
    }
    
    fileprivate func displaySkinImage(with partFragment: ImagePartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            return
        }
        
        let bundle = Bundle(for: type(of: self))
        self.skinImageView.image = UIImage(named: partFragment!.imageUrlString, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
    
    fileprivate func displayBookmarkImage(with partFragment: ImagePartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            return
        }
        
        let bundle = Bundle(for: type(of: self))
        self.bookmarkImageView.image = UIImage(named: partFragment!.imageUrlString, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
    
    fileprivate func setupBookmarkImagePartFragment() {
//        let bookmarkStatus = self.viewDelegate?.isArticleBookmarked() ?? false
//        self.bookmarkStatusChanged(added: bookmarkStatus)
    }
    
    func bookmarkStatusChanged(added: Bool) {
        if added {
            self.setActiveBookmarkImage()
        }else {
            self.setInactiveBookmarkImage()
        }
    }
    
    fileprivate func setActiveBookmarkImage() {
        DispatchQueue.main.async {
            self.isBookmarkedItemSectionView = true
//            self.initializeBookmarkImage(with: self.partFragment.activeBookmarkImage)
//            self.displayBookmarkImage(with: self.partFragment.activeBookmarkImage)
        }
    }
    
    fileprivate func setInactiveBookmarkImage() {
        DispatchQueue.main.async {
//            self.isBookmarkedItemSectionView = false
//            self.initializeBookmarkImage(with: self.partFragment.inactiveBookmarkImage)
//            self.displayBookmarkImage(with: self.partFragment.inactiveBookmarkImage)
        }
    }
}

extension BookmarkSectionView {
    @objc func headerLabelTapped(_ sender: UITapGestureRecognizer) {
//        if let header = self.partFragment.header {
//            self.partFragment.delegate?.handleHeaderTapEvent(header: header)
//        }
    }
    
    @objc func bookmarkIconTapped(_ sender: UITapGestureRecognizer) {
//        if self.isBookmarkedItemSectionView {
//            self.viewDelegate?.removeBookmark(completion: {[weak self] success in
//                if success {
//                    self?.bookmarkStatusChanged(added: false)
//                }
//            })
//        }else {
//            self.viewDelegate?.addBookmark(completion: {[weak self] success in
//                if success {
//                    self?.bookmarkStatusChanged(added: true)
//                }
//            })
//        }
    }
}
