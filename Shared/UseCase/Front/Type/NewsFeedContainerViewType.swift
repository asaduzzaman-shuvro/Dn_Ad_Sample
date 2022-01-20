//
//  NewsFeedContainerViewType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 23/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

protocol NewsFeedContainerViewType: EditingCollectionViewContainerType, BlockingProgressEventListenerViewType, NonBlockingProgressEventListenerViewType, RefreshEventListenerViewType, EmptyStateViewType {}
