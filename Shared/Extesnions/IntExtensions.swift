//
//  IntExtensions.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/12/21.
//  Copyright © 2021 no.dn.dn. All rights reserved.
//

import Foundation

extension Int {
    /// Checks if an index is valid for an `Array`.
    ///
    /// - Parameter array: The array to which the index might belong to.
    /// - Returns: Returns `true` if it is an valid index, otherwise returns `false`.
    func isValidIndex(in array: Array<Any>) -> Bool {
        if self >= array.startIndex && self <= array.endIndex {
            return true
        }
        return false
    }
}
