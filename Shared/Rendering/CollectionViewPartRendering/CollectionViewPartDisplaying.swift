//
//  CollectionViewPartDisplaying.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

protocol CollectionViewPartDisplaying: AnyObject {
    func initializeView(with part: CollectionViewFeedPart)
    func displayPart(_ part: CollectionViewFeedPart)
    
}


//------------------------------------------
//MARK:- For Vidio Display
//------------------------------------------
protocol CollectionViewVideoPartDisplaying:  CollectionViewPartDisplaying {
    func attachPlayerToView()
    func removePlayerFromView()
}
