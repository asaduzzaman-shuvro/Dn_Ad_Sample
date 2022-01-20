//
//  EmptyStateView.swift
//  DNApp
//
//  Created by Asaduzzaman Shuvro on 15/9/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import UIKit

class ErrorStateView: UIView {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    var didPressOnRefresh: (() -> Void)?
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        commonInitailization()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInitailization()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func pressOnRefreshButton(_ sender: Any) {
        self.didPressOnRefresh?()
    }
}

extension ErrorStateView {
    private func commonInitailization() {
        self.backgroundColor = UIColor.feedBackgroundColor()
    }
    
    @objc private func pressOnRefreshButton(sender: Any) {
        self.refetchApis()
        self.didPressOnRefresh?()
    }
    
    private func refetchApis() {
    }
    
    private func updateIconImage(_ image: UIImage?) {
        self.iconImageView.tintColor = UIColor.shadesOfGrey07()
        self.iconImageView.image = image
    }
    
    private func update(title: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 14),
            .foregroundColor : UIColor.shadesOfGrey09(),
            .paragraphStyle : paragraphStyle
        ]
        
        self.titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
    }
    
    private func update(description: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 16),
            .foregroundColor : UIColor.shadesOfGrey07(),
            .paragraphStyle : paragraphStyle
        ]
        
        self.descriptionLabel.attributedText = NSAttributedString(string: description, attributes: attributes)
    }
    
    private func updateRefreshButton(title: String) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.81
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 14),
            .foregroundColor : UIColor.shadesOfBlue04()
        ]
        
        self.refreshButton.setAttributedTitle(NSAttributedString(string: title.uppercased(), attributes: attributes), for: .normal)
        
    }
}

extension ErrorStateView {
    func update(with viewModel: EmptyStateViewModel) {
        self.updateIconImage(viewModel.iconImage)
        self.update(title: viewModel.title)
        self.update(description: viewModel.description)
        self.updateRefreshButton(title: viewModel.refreshButtonTitle)
    }
}



