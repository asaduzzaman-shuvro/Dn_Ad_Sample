//
//  DFPAdCollectionViewCell.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 15/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DFPAdCollectionViewCell: CollectionViewCell {
    @IBOutlet weak var adContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var adContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var adContainerView: UIView!
    
    @IBOutlet weak var busyIndicator: UIActivityIndicatorView!
    
    private var shouldUpdateCellHeight: Bool = false
    fileprivate var part: DFPAdPart!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.shouldUpdateCellHeight = false
    }
    
    override func initializeView(with part: CollectionViewFeedPart) {
        super.initializeView(with: part)
        
        self.startLoadingAnimation()
    }
    
    override func displayPart(_ part: CollectionViewFeedPart) {
        super.displayPart(part)
        
        guard let part = part as? DFPAdPart, part.size.height > .zero else {
            return
        }
        
        self.part = part
        
        self.adContainerView.subviews.forEach {
            if let adView = $0 as? GAMBannerView {
                adView.removeFromSuperview()
            }
        }
        
        if let dfpAdView = self.part.delegate?.fetchAdView(adViewIdentifier: part.adUniqueIdentifier){
            guard !dfpAdView.adFailed else {
                self.hideCell()
                return
            }
            
            self.stopLoadingAnimation()
            updateAdContainerSize(updatedSize: part.loadedAdSize)
            addBannerViewToView(bannerView: dfpAdView.adBannerView)
        }
        else{
            if let viewController = part.delegate?.getRootViewController() {
                let customAdSize = GADAdSizeFromCGSize(part.loadedAdSize)
                
                let adView = GAMBannerView(adSize: customAdSize)
                adView.adUnitID = part.adAlias
                adView.validAdSizes = self.getValidAdSizes()
                adView.rootViewController = viewController
                adView.delegate = self
                adView.adSizeDelegate = self
                
                updateAdContainerSize(updatedSize: part.loadedAdSize)
                addBannerViewToView(bannerView: adView)
                
                DispatchQueue.main.async {
                    adView.load(GAMRequest())
                }
            }else {
                self.hideCell()
            }
        }
    }
    
    private func getValidAdSizes() -> [NSValue] {
        var validAdSizes = [NSValue]()
        
        let screenWidth = FeedAppearanceProvider.sharedInstance.feedWidth
        
        if screenWidth >= 160 {
            validAdSizes.append(NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSize(width: 160, height: 600))))
        }
        
        if screenWidth >= 300 {
            validAdSizes.append(NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSize(width: 300, height: 250))))
            validAdSizes.append(NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSize(width: 300, height: 600))))
        }
        if screenWidth >= 320 {
            validAdSizes.append(NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSize(width: 320, height: 50))))
            validAdSizes.append(NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSize(width: 320, height: 100))))
            validAdSizes.append(NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSize(width: 320, height: 320))))
            validAdSizes.append(NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSize(width: 320, height: 400))))
            validAdSizes.append(NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSize(width: 320, height: 480))))
        }
        if screenWidth >= 580 {
            validAdSizes.append(NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSize(width: 580, height: 400))))
        }
        if screenWidth >= 728 {
            validAdSizes.append(NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSize(width: 728, height: 90))))
        }
        if screenWidth >= 768 {
            validAdSizes.append(NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSize(width: 768, height: 90))))
        }
        if screenWidth >= 970 {
            validAdSizes.append(NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSize(width: 970, height: 250))))
        }
        if screenWidth >= 980 {
            validAdSizes.append(NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSize(width: 980, height: 300))))
        }
        
        return validAdSizes
    }
    
    private func addBannerViewToView(bannerView: UIView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.adContainerView.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: self.adContainerView.topAnchor),
            bannerView.leadingAnchor.constraint(equalTo: self.adContainerView.leadingAnchor),
            self.adContainerView.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor),
            self.adContainerView.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor)
        ])
    }
    
    private func updateAdContainerSize(updatedSize size: CGSize) {
        self.adContainerViewWidthConstraint.constant = size.width
        self.adContainerViewHeightConstraint.constant = size.height
    }
    
    private func startLoadingAnimation() {
        self.busyIndicator.startAnimating()
        self.adContainerView.isHidden = true
    }
    
    private func stopLoadingAnimation() {
        self.adContainerView.isHidden = false
        self.busyIndicator.stopAnimating()
    }
    
    private func shouldChangeCellHeight(adHeight: CGFloat) -> Bool {
        return self.part.size.height != adHeight
    }
    
    private func shouldChangeAdSize(size: CGSize) -> Bool {
        return self.part.loadedAdSize.width != size.width || self.part.loadedAdSize.height != size.height
    }
    
    private func changeAdSize(size: CGSize) {
        self.shouldUpdateCellHeight = true
        self.part.changeLoadedAdSize(size: size)
        self.updateAdContainerSize(updatedSize: size)
    }
    
    private func changeCellHeight(updatedHeight: CGFloat) {
        if self.part.isResizable {
            self.part.delegate?.adjustHeightForDynamicContent(at: self.part.representingIndexPath, height: updatedHeight)
        }
    }
    
    private func hideCell() {
        if self.part.isRemovable {
            self.part.delegate?.adjustHeightForDynamicContent(at: self.part.representingIndexPath, height: .zero)
        }
    }
}

//MARK: - GADBannerViewDelegate
extension DFPAdCollectionViewCell: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        log(object: "Ad loaded successfully for alias: \(self.part.adAlias) on index: \(self.part.representingIndexPath.row)")
        
        self.part.delegate?.cacheAdView(adViewIdentifier: self.part.adUniqueIdentifier, bannerView: bannerView, adFailed: false)
        self.stopLoadingAnimation()
        
        if self.shouldUpdateCellHeight {
            self.changeCellHeight(updatedHeight: self.part.loadedAdSize.height)
        }
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        log(object: "Something wrong with DFPAD fetching: \(error.localizedDescription)")
        
        self.part.delegate?.cacheAdView(adViewIdentifier: self.part.adUniqueIdentifier, bannerView: bannerView, adFailed: true)
        self.stopLoadingAnimation()
        
        self.hideCell()
    }
}

//MARK: - GADAdSizeDelegate
extension DFPAdCollectionViewCell: GADAdSizeDelegate {
    func adView(_ bannerView: GADBannerView, willChangeAdSizeTo size: GADAdSize) {
        if shouldChangeAdSize(size: size.size) {
            self.changeAdSize(size: size.size)
        }
    }
}
