//
//  BaseFeedViewController.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit
import  NVActivityIndicatorView

class BaseFeedViewController: UIViewController, EditingCollectionViewContainerType {
    @IBOutlet weak var collectionView: UICollectionView?
    weak var refreshControl: UIRefreshControl?
    weak var activityIndicatorView: NVActivityIndicatorView!

    let contentProvider = CollectionViewFeedContentProvider(rendererFactory: CollectionViewPartRendererFactory())
    
    var scrollDirection: UICollectionView.ScrollDirection {
        return .vertical
    }
    
    var disableRefresh: Bool {
        return false
    }
    
    fileprivate func initializeCollectionViewCustomLayout(_ layout: CollectionViewCustomLayout) {
        layout.infoProvider = self.contentProvider
        layout.scrollDirection = self.scrollDirection
    }
    
    func createCollectionView() -> UICollectionView {
        let collectionViewFlowLayout = CollectionViewCustomLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRefreshControl()
        self.setupActivityIndicatorView()
        
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.backgroundColor = .clear
        
        if let collectionViewCustomLayout = self.collectionView?.collectionViewLayout as? CollectionViewCustomLayout {
            self.initializeCollectionViewCustomLayout(collectionViewCustomLayout)
        }
        
        let bundle = Bundle(for: type(of: self))
        self.collectionView?.register(UINib(nibName: "DFPAdCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: "DFPAdCollectionViewCell")
        self.collectionView?.register(UINib(nibName: "ArticleSummaryNormalCell", bundle: bundle), forCellWithReuseIdentifier: "ArticleSummaryNormalCellReuseId")

        self.collectionView?.decelerationRate = .normal
    }
    
    func startProgressAnimation() {
        self.toggleCollectionViewVisibleState(hide: true)
        DispatchQueue.main.async {
            self.activityIndicatorView?.startAnimating()
        }
    }
    
    func stopProgressAnimation() {
        self.toggleCollectionViewVisibleState(hide: false)
        DispatchQueue.main.async {
            self.activityIndicatorView?.stopAnimating()
        }
    }
        
    func toggleCollectionViewInteractionState(enable: Bool) {
        DispatchQueue.main.async {
            self.collectionView?.isUserInteractionEnabled = enable
        }
    }
    
    func toggleCollectionViewVisibleState(hide: Bool) {
        DispatchQueue.main.async {
            self.collectionView?.isHidden = hide
        }
    }
    
    @objc func handlePullToRefresh(_ sender: UIRefreshControl) {
        self.toggleCollectionViewInteractionState(enable: false)
    }
    
    func endRefreshing() {
        self.toggleCollectionViewInteractionState(enable: true)
        
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
        }
    }
        
    // MARK: - CollectionViewEditingContainerType
    
    func getCollectionView() -> UICollectionView? {
        return self.collectionView
    }
    
    func getCollectionViewScrollDirection() -> UICollectionView.ScrollDirection {
        return self.scrollDirection
    }
    
    func getCollectionViewBounds() -> CGSize {
        return self.collectionView?.bounds.size ?? .zero
    }
    
    func getIndexPath(for cell: UICollectionViewCell) -> IndexPath? {
        return self.collectionView?.indexPath(for: cell)
    }
    
    func reload(with sectionInfos: [CollectionViewSectionInfoProviding]) {
        self.contentProvider.updateSectionInfo(with: sectionInfos)
        
        DispatchQueue.main.async {[weak self] in
            self?.collectionView?.reloadData()
        }
    }
    
    func reload() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
        }
    }

    func adjustHeightForDynamicContent(at indexPath: IndexPath, height: CGFloat) {
        self.contentProvider.adjustHeightForDynamicContent(at: indexPath, height: height)
        DispatchQueue.main.async {
            self.collectionView?.reloadItems(at: [indexPath])
        }
    }
    
    func getLastCell() -> IndexPath? {
        let lastSection = getNumberOfSections() - 1
        let lastItem = getNumberOfItems(inSection: lastSection) 
        return IndexPath(item: lastItem, section: lastSection)
    }
    
    func getNumberOfSections() -> Int {
        return self.contentProvider.numberOfSections()
    }
    
    func getNumberOfItems(inSection section: Int) -> Int {
        return self.contentProvider.numberOfItems(inSection: section)
    }
    
    func reload(part: CollectionViewFeedPart, atIndexPath indexPath: IndexPath) {
        self.contentProvider.prepareForItemReload(at: indexPath, item: part)
    }
    
    func insert(part: CollectionViewFeedPart, atIndexPath indexPath: IndexPath) {
        self.contentProvider.prepareForItemInsertion(at: indexPath, item: part)
    }
    
    func insert(parts: [CollectionViewFeedPart], startingAt indexPath: IndexPath) {
        self.contentProvider.prepareForItemsInsertion(startingAt: indexPath, items: parts)
    }
    
    func removeItem(at indexPath: IndexPath) {
        self.contentProvider.prepareForItemRemoval(at: indexPath)
    }
        
    func performUpdates() {
        let indexPathsToReload = self.contentProvider.getItemsToBeReloaded()
        let indexPathsToDelete = self.contentProvider.getItemsToBeRemoved()
        let indexPathsToAdd = self.contentProvider.getItemsToBeInserted()
        
        DispatchQueue.main.async {
            self.collectionView?.performBatchUpdates({
                self.collectionView?.reloadItems(at: indexPathsToReload)
                self.collectionView?.deleteItems(at: indexPathsToDelete)
                self.collectionView?.insertItems(at: indexPathsToAdd)
            }, completion: { success in
                self.contentProvider.clearUpdateStatusInfo()
            })
        }
    }
}

extension BaseFeedViewController {
    fileprivate func setupRefreshControl() {
        func getRefreshControlTintColor(backgroundColor: UIColor) -> UIColor {
            if backgroundColor.colorType == .dark {
                return UIColor.white
            }else {
                return UIColor.shadesOfGrey09()
            }
        }
        
        if !self.disableRefresh {
            let refreshControl = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            refreshControl.tintColor = .gray
            
            refreshControl.addTarget(self, action: #selector(BaseFeedViewController.handlePullToRefresh(_:)), for: .valueChanged)
            
            self.refreshControl = refreshControl
            self.collectionView?.refreshControl = refreshControl
        }
    }
}

//MARK: - UICollectionViewDataSource
extension BaseFeedViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contentProvider.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentProvider.numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return contentProvider.getCell(collectionView, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return contentProvider.getSectionHeaderView(collectionView, indexPath: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BaseFeedViewController: UICollectionViewDelegateFlowLayout {
    var collectionViewFlowLayoutInfoProvider: CollectionViewFlowLayoutInfoProvider? {
        return self.contentProvider
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionViewFlowLayoutInfoProvider?.collectionView(collectionView, sizeForItemAt: indexPath) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionViewFlowLayoutInfoProvider?.collectionView(collectionView, insetForSectionAt: section) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return collectionViewFlowLayoutInfoProvider?.collectionView(collectionView, referenceSizeForHeaderIn: section) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return collectionViewFlowLayoutInfoProvider?.collectionView(collectionView, referenceSizeForFooterIn: section) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewFlowLayoutInfoProvider?.collectionView(collectionView, minimumInteritemSpacingForSectionAt: section) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewFlowLayoutInfoProvider?.collectionView(collectionView, minimumLineSpacingForSectionAt: section) ?? .zero
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentProvider.updateVideoPlaying(in: self.collectionView)
    }
}



extension BaseFeedViewController {
    fileprivate func setupActivityIndicatorView() {
        let activityIndicatorView = NVActivityIndicatorView(frame: .zero)
        activityIndicatorView.type = .circleStrokeSpin
        activityIndicatorView.color = self.view.backgroundColor?.colorType == .light ? UIColor.shadesOfGrey09() : UIColor.loadingSpinnercolor()
        activityIndicatorView.padding = 20
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 150),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 150),
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.safeCenterXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.safeCenterYAnchor)
        ])
        
        self.activityIndicatorView = activityIndicatorView
    }
}
