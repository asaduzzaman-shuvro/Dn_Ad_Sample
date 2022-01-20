//
//  Builder.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

protocol Builder {
    associatedtype T
    func build() -> T
}
