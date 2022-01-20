//
//  SearchViewPresentingController.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 27/8/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol SearchViewPresentingController: AnyObject {
    func dismissSearchView(_ viewController: UIViewController)
    func showSearchResultViewController(withQuery string: String)
}
