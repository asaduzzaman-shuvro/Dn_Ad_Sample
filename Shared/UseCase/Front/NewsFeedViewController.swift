//
//  NewsFeedViewController.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 23/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class NewsFeedViewController: BaseFeedViewController, NewsFeedContainerViewType {
    
    func startBlockingProgressAnimation() {
        
    }
    
    func stopBlockingProgressAnimation() {
        
    }
    
    var pageIndex: Int = 0
    
    @IBOutlet weak var collectionViewLeadingMargin: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTrailingMargin: NSLayoutConstraint!
        
    lazy var errorStateView: ErrorStateView = {
        let errorStateView = ErrorStateView.fromNib()
        return errorStateView
    }()
    
    var feedDelegate: NewsFeedViewControllerDelegate?

    override func loadView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: NewsFeedViewController.self), bundle: bundle)
        let contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.collectionViewLeadingMargin.constant = 20
        self.collectionViewTrailingMargin.constant = 20
        
        self.feedDelegate?.start()
        
        self.setupErrorStateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
    }
    
    override func handlePullToRefresh(_ sender: UIRefreshControl) {
        super.handlePullToRefresh(sender)
        self.feedDelegate?.refresh(pullToRefresh: true)
    }
    
    override func getCollectionViewBounds() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: .greatestFiniteMagnitude)
    }
    
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        super.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
//        feedDelegate?.scrollViewWillEndDragging(scrollView)
//    }
}


extension NewsFeedViewController {
    func setupErrorStateView() {
        self.errorStateView.isHidden = true
        self.errorStateView.didPressOnRefresh = { [weak self] in
            self?.feedDelegate?.refetchDataForError()
            self?.hideEmptyErrorView()
        }
        self.errorStateView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.errorStateView)
        NSLayoutConstraint.activate([
            self.errorStateView.safeLeadingAnchor.constraint(equalTo: self.view.safeLeadingAnchor),
            self.errorStateView.safeTrailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor),
            self.errorStateView.safeTopAnchor.constraint(equalTo: self.view.safeTopAnchor),
            self.errorStateView.safeBottomAnchor.constraint(equalTo: self.view.safeBottomAnchor),
        ])
    }
    
    func showEmptyState(with viewModel: EmptyStateViewModel) {
        DispatchQueue.main.async {
            self.errorStateView.update(with: viewModel)
            self.errorStateView.isHidden = false
            self.toggleCollectionViewVisibleState(hide: true)
        }
    }
    
    func hideEmptyErrorView() {
        DispatchQueue.main.async {
            self.errorStateView.isHidden = true
        }
    }
}

//MARK: - UICollectionDelegateFlowLayout
extension NewsFeedViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let part = self.contentProvider.getContent(at: indexPath) {
            self.feedDelegate?.partSelected(part)
        }
    }
}

////MARK: - TabBarViewControllerType
//extension NewsFeedViewController: TabBarViewControllerType {
//    func navigateToTop() {
//        if self.contentProvider.numberOfSections() > 0 {
//            self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: self.scrollDirection == .vertical ? .top : .left, animated: true)
//        }
//    }
//}


