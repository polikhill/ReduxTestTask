//
//  IGListKitExtensions.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/9/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import IGListKit

extension ListCollectionContext {
    func cell<T: BaseCollectionViewCell>(cellType: T.Type, index: Int, for controller: ListSectionController) -> T? {
        guard let cell = self.dequeueReusableCell(
            withNibName: "\(cellType)",
            bundle: nil,
            for: controller,
            at: index) as? T else {
                return nil
        }
        return cell
    }
}
