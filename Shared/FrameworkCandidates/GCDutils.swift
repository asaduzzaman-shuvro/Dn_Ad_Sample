//
// Created by Apps AS on 04/04/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation

func dispatchOnMainAfter(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
