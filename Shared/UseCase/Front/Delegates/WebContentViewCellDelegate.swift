//
//  WebContentViewCellDelegate.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 4/7/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

protocol WebContentViewCellDelegate: AnyObject {
    func open(_ url: URL)
    func open(_ urlString: String)
}
