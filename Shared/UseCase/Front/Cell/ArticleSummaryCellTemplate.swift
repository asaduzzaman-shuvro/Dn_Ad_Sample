//
//  ArticleSummaryCellTemplate.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 3/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit
class ArticleSummaryCellTemplate: CollectionViewCell {
    @IBOutlet weak var articleImageTopMargin: NSLayoutConstraint!
    @IBOutlet weak var articleImageLeadingMargin: NSLayoutConstraint!
    @IBOutlet weak var sizePropertyDefiningMargin: NSLayoutConstraint!
    @IBOutlet weak var expandableSizeProperty: NSLayoutConstraint!
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBOutlet weak var videoIconOverlay: UIView!
    
    @IBOutlet weak var smallBadgeViewWidth: NSLayoutConstraint!
    @IBOutlet weak var smallBadgeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var smallBadgeView: BadgeView!
    
    @IBOutlet weak var largeBadgeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var largeBadgeView: BadgeView!
    
    @IBOutlet weak var articleTextPortionView: ArticleSummaryTextPortionView!

    
    fileprivate var part: ArticleSummaryPart!
    
    override func setupViews() {
        super.setupViews()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(ArticleSummaryCellTemplate.checkBookmarkStatus(_:)), name: Notification.Name(rawValue: UseCaseNotification.BookmarkedArticleIdListUpdatedNotification), object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func initializeView(with part: CollectionViewFeedPart) {
        super.initializeView(with: part)
        
        guard let part = part as? ArticleSummaryPart else {
            return
        }
        
        self.initializeImage(with: part.image)
        let isImageShown = !self.isPartFragmentEmpty(part.image)
        self.initializeVideoIcon(isVideoArticle: part.isVideoArticle, isImageShown: isImageShown)
        self.initializeBadge(with: part.badge, isImageShown: isImageShown, shouldShowFullWidthBadge: part.shouldShowFullWidthBadge)
        
        self.articleTextPortionView.contentView.backgroundColor = part.backgroundColor
        self.articleTextPortionView.initializeAuthorImage(with:part.authorImage)
        self.articleTextPortionView.initializeKicker(with: part.kicker)
        self.articleTextPortionView.initializeTitle(with: part.title)
        self.articleTextPortionView.initializeLeadText(with: part.leadText)
//        self.articleTextPortionView.initializeBookmarkSection(with: part.bookmarkSection)
//        self.articleTextPortionView.setBookmarkSectionViewDelegate(self)
    }
    
    func setupImageSize(size: CGSize, margins: Margins) {}
    
    override func displayPart(_ part: CollectionViewFeedPart) {
        super.displayPart(part)
        
        guard let part = part as? ArticleSummaryPart else {
            return
        }
        
        self.part = part
        
        self.displayImage(with: part.image)
        self.displayBadge(with: part.badge, isImageShown: !self.isPartFragmentEmpty(part.image), shouldShowFullWidthBadge: part.shouldShowFullWidthBadge)
        self.articleTextPortionView.displayAuthorImage(with: part.authorImage)
        self.articleTextPortionView.displayKicker(with: part.kicker)
        self.articleTextPortionView.displayTitle(with: part.title)
        self.articleTextPortionView.displayLeadText(with: part.leadText)
//        self.articleTextPortionView.displayBookmarkSection(with: part.bookmarkSection)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ArticleSummaryCellTemplate {
    fileprivate func isPartFragmentEmpty(_ partFragment: PartFragment?) -> Bool {
        return partFragment == nil || partFragment?.size.width == .zero || partFragment?.size.height == .zero
    }
    
    fileprivate func hideImageContent() {
        self.articleImageTopMargin.constant = .zero
        self.articleImageLeadingMargin.constant = .zero
        self.sizePropertyDefiningMargin.constant = .zero
        
        self.expandableSizeProperty.constant = .zero
    }
    
    fileprivate func hideSmallBadgeView() {
        self.smallBadgeView.prepareViewForHiding()
        self.smallBadgeView.hideView(topMargin: nil, bottomMargin: nil, leadingMargin: nil, trailingMargin: nil, widthConstraint: nil, heightConstraint: self.smallBadgeViewHeight)
    }
    
    fileprivate func hideLargeBadgeView() {
        self.largeBadgeView.prepareViewForHiding()
        self.largeBadgeView.hideView(topMargin: nil, bottomMargin: nil, leadingMargin: nil, trailingMargin: nil, widthConstraint: nil, heightConstraint: self.largeBadgeViewHeight)
    }
}

extension ArticleSummaryCellTemplate {    
    fileprivate func initializeImage(with partFragment: ImagePartFragment?) {
        guard !(partFragment?.isEmpty() ?? true) else {
            self.hideImageContent()
            return
        }
        
        self.articleImageView.isHidden = false
        self.articleImageTopMargin.constant = partFragment!.margins.top
        self.articleImageLeadingMargin.constant = partFragment!.margins.left
        self.articleImageView.backgroundColor = partFragment!.backgroundColor
        
        self.setupImageSize(size: partFragment!.size, margins: partFragment!.margins)
    }
    
    fileprivate func initializeVideoIcon(isVideoArticle: Bool, isImageShown: Bool) {
        guard isVideoArticle && isImageShown else {
            self.videoIconOverlay.isHidden = true
            return
        }
        
        self.videoIconOverlay.isHidden = false
    }
    
    fileprivate func initializeBadge(with partFragment: BadgePartFragment?, isImageShown: Bool, shouldShowFullWidthBadge: Bool = false) {
        guard !(partFragment?.isEmpty() ?? true) else {
            self.hideSmallBadgeView()
            self.hideLargeBadgeView()
            return
        }
        
        if shouldShowFullWidthBadge || !isImageShown {
            self.showBigBadgeView(partFragment: partFragment!)
        }else{
            self.showSmallBadgeView(partFragment: partFragment!)
        }
    }
    
    fileprivate func showSmallBadgeView(partFragment: BadgePartFragment){
        self.hideLargeBadgeView()
        self.smallBadgeView.isHidden = false
        self.smallBadgeViewWidth.constant = partFragment.size.width
        self.smallBadgeViewHeight.constant = partFragment.size.height
        self.smallBadgeView.prepareViewForShow()
        self.smallBadgeView.initialize(with: partFragment)
    }
    
    fileprivate func showBigBadgeView(partFragment: BadgePartFragment){
        self.hideSmallBadgeView()
        self.largeBadgeView.isHidden = false
        self.largeBadgeViewHeight.constant = partFragment.size.height
        self.largeBadgeView.prepareViewForShow()
        self.largeBadgeView.initialize(with: partFragment)
    }
}

extension ArticleSummaryCellTemplate {
    fileprivate func displayImage(with partFragment: ImagePartFragment?) {
        guard !self.isPartFragmentEmpty(partFragment) else {
            return
        }
        
        if let imageUrl = URL(string: partFragment!.imageUrlString) {
//            self.articleImageView.sd_setImage(with: imageUrl, completed: nil)
        }
    }
    
    fileprivate func displayBadge(with partFragment: BadgePartFragment?, isImageShown: Bool, shouldShowFullWidthBadge: Bool) {
        guard !self.isPartFragmentEmpty(partFragment) else {
            return
        }
        
        if shouldShowFullWidthBadge || !isImageShown {
            self.largeBadgeView.display(with: partFragment!)
        }else{
            self.smallBadgeView.display(with: partFragment!)
        }
    }
}

//extension ArticleSummaryCellTemplate {
//    @objc func checkBookmarkStatus(_ notification: NSNotification) {
//        if let articleId = notification.userInfo?[DNBookmarkDataManager.updateNotificationValueKey] as? String,
//            let operation = notification.userInfo?[DNBookmarkDataManager.updateNotificationOperationKey] as? String,
//            articleId == self.part.articleId {
//            self.articleTextPortionView.bookmarkStatusChanged(added: DNBookmarkDataManager.UpdateOperation.isAddOperation(operation))
//        }
//    }
//}

//MARK: - BookmarkSectionViewDelegate
//extension ArticleSummaryCellTemplate: BookmarkSectionViewDelegate {
//    func isArticleBookmarked() -> Bool {
//        return DNBookmarkDataManager.sharedInstance.isArticleBookmarked(self.part.articleId)
//    }
//
//    func addBookmark(completion: @escaping (Bool) -> Void) {
////        self.part.title?.attributedString.string
//
//        self.part.bookmarkSection?.delegate?.addBookmark(cell: self, articleId: self.part.articleId, articleTitle: self.part.title?.attributedString.string ?? "", completion: completion)
////        self.part.bookmarkSection?.delegate?.addBookmark(cell: self, articleId: self.part.articleId, completion: completion)
//    }
//
//    func removeBookmark(completion: @escaping (Bool) -> Void) {
//
//        self.part.bookmarkSection?.delegate?.removeBookmark(cell: self, articleId: self.part.articleId, articleTitle: self.part.title?.attributedString.string ?? "", completion: completion)
//    }
//}
