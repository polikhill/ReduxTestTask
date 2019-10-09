//
//  BaseCollectionViewCell.swift
//  ZablotskyDental
//
//  Created by Dima Ripa on 8/27/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    class var cellNib: UINib? {
        let nibName = self.description().components(separatedBy: ".").last!
        return UINib(nibName: nibName, bundle: nil)
    }
}
