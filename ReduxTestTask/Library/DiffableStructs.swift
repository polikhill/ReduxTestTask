//
//  DiffableStructs.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/4/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import IGListKit

public protocol Diffable: Equatable {
    
    /**
     Returns a key that uniquely identifies the object.
     
     - returns: A key that can be used to uniquely identify the object.
     
     - note: Two objects may share the same identifier, but are not equal.
     
     - warning: This value should never be mutated.
     */
    var diffIdentifier: String { get }
}

final class DiffableBox<T: Diffable>: ListDiffable {
    
    let value: T
    let identifier: NSObjectProtocol
    let equal: (T, T) -> Bool
    
    init(value: T, identifier: NSObjectProtocol, equal: @escaping(T, T) -> Bool) {
        self.value = value
        self.identifier = identifier
        self.equal = equal
    }
    
    // IGListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let other = object as? DiffableBox<T> {
            return equal(value, other.value)
        }
        return false
    }
}
