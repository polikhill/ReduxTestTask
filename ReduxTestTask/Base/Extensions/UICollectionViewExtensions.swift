//
//  UICollectionViewExtensions.swift
//  ZablotskyDental
//
//  Created by Dima Ripa on 8/27/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import UIKit

extension UICollectionView {

    func register<T: BaseCollectionViewCell>(cellType: T.Type) {
        guard let nib = T.cellNib else { return }
        let identifier = "\(cellType)"
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }

    func cell<T: BaseCollectionViewCell>(cellType: T.Type, indexPath: IndexPath) -> T? {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: "\(cellType)", for: indexPath) as? T else {
            return nil
        }
        return cell
    }
}
