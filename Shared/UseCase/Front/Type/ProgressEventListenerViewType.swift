//
//  ProgressEventListenerViewType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 16/7/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

protocol BlockingProgressEventListenerViewType: AnyObject {
    func startBlockingProgressAnimation()
    func stopBlockingProgressAnimation()
}

protocol NonBlockingProgressEventListenerViewType: AnyObject {
    func startProgressAnimation()
    func stopProgressAnimation()
}

protocol RefreshEventListenerViewType: AnyObject {
    func endRefreshing()
}


protocol EmptyStateViewType: AnyObject {
    func setupErrorStateView()
    func showEmptyState(with viewModel: EmptyStateViewModel)
    func hideEmptyErrorView()
}
