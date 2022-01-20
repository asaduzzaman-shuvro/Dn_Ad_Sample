//
//  CollectionViewDecorationViewHandler.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewDecorationViewHandler {
    typealias DecorationIndexPaths = [String : [IndexPath]]
    
    weak var collectionViewLayout: UICollectionViewLayout?
    
    var elementKinds = [String] ()
    var indexPathCounter = DecorationIndexPaths()
    var oldIndexPathCounter = DecorationIndexPaths()
    
    var insertedIndexPath = DecorationIndexPaths()
    var deletedIndexPath = DecorationIndexPaths()
    
    init(collectionViewLayout: UICollectionViewLayout) {
        self.collectionViewLayout = collectionViewLayout
    }
    
    func register(_ viewClass: AnyClass, forDecorationViewOfKind elementKind: String) {
        if let _ = indexPathCounter[elementKind] {
            return
        }
        
        elementKinds.append(elementKind)
        indexPathCounter[elementKind] = [IndexPath] ()
        self.collectionViewLayout?.register(viewClass, forDecorationViewOfKind: elementKind)
    }
    
    func register(_ nib: UINib, forDecorationViewOfKind elementKind: String) {
        if let _ = indexPathCounter[elementKind] {
            return
        }
        
        elementKinds.append(elementKind)
        indexPathCounter[elementKind] = [IndexPath] ()
        self.collectionViewLayout?.register(nib, forDecorationViewOfKind: elementKind)
    }
    
    func elementKinds(for indexPath: IndexPath, in decorationIndexPath: DecorationIndexPaths) -> [String] {
        var elementKinds = [String] ()
        
        decorationIndexPath.forEach { (elementKind, value) in
            if value.contains(indexPath) {
                elementKinds.append(elementKind)
            }
        }
        
        return elementKinds
    }
    
    func prepare() {
        oldIndexPathCounter = indexPathCounter
        elementKinds.forEach { elementKind in
            indexPathCounter[elementKind]?.removeAll()
        }
    }
    
    func add(indexPath: IndexPath, forDecorationViewOfKind elementKind: String) {
        self.indexPathCounter[elementKind]?.append(indexPath)
    }
    
    func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        elementKinds.forEach { elementKind in
            insertedIndexPath[elementKind] = [IndexPath] ()
            deletedIndexPath[elementKind] = [IndexPath] ()
        }
        
        updateItems.forEach { updateItem in
            switch updateItem.updateAction {
            case .delete:
                guard let indexPathBeforeDelete = updateItem.indexPathBeforeUpdate else {
                    break
                }
                
                self.elementKinds(for: indexPathBeforeDelete, in: oldIndexPathCounter).forEach { elementKind in
                    deletedIndexPath[elementKind]?.append(indexPathBeforeDelete)
                }
            case .insert:
                guard let indexPathAfterUpdate = updateItem.indexPathAfterUpdate else {
                    break
                }
                
                self.elementKinds(for: indexPathAfterUpdate, in: indexPathCounter).forEach { elementKind in
                    insertedIndexPath[elementKind]?.append(indexPathAfterUpdate)
                }
            case .reload, .move:
                guard let indexPathBeforeUpdate = updateItem.indexPathBeforeUpdate,
                    let indexPathAfterUpdate = updateItem.indexPathAfterUpdate else {
                        break
                }
                
                self.elementKinds(for: indexPathBeforeUpdate, in: oldIndexPathCounter).forEach { elementKind in
                    deletedIndexPath[elementKind]?.append(indexPathBeforeUpdate)
                }
                
                self.elementKinds(for: indexPathAfterUpdate, in: indexPathCounter).forEach { elementKind in
                    insertedIndexPath[elementKind]?.append(indexPathAfterUpdate)
                }
            default:
                break
            }
        }
    }
    
    func getInsertedIndexPath(forDecorationViewOfKind elementKind: String) -> [IndexPath] {
        return insertedIndexPath[elementKind] ?? []
    }
    
    func getDeletedIndexPath(forDecorationViewOfKind elementKind: String) -> [IndexPath] {
        return deletedIndexPath[elementKind] ?? []
    }
}
