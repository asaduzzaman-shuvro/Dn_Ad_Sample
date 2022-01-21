//
//  ArticleSummaryNormalCell.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 23/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import UIKit

class ArticleSummaryNormalCell: ArticleSummaryCellTemplate {
    override func setupImageSize(size: CGSize, margins: Margins) {
        self.expandableSizeProperty.constant = size.width
        self.sizePropertyDefiningMargin.constant = margins.bottom
    }
}
