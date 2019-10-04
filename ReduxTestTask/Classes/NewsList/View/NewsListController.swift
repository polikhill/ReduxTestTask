//
//  NewsListController.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/4/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit
import IGListKit

final class NewsListController: ListBindingSectionController<DiffableBox<NewsCell.Props>>, ListBindingSectionControllerDataSource {
   
    override init() {
        super.init()
        dataSource = self
    }
}

extension NewsListController {
    func sectionController(
        _ sectionController: ListBindingSectionController<ListDiffable>,
        viewModelsFor object: Any
        ) -> [ListDiffable] {
        
        guard let news = object as? DiffableBox<NewsCell.Props> else { return [] }
        let diffableNews: [ListDiffable] = [news]
        
        return diffableNews
    }
    
    func sectionController(
        _ sectionController: ListBindingSectionController<ListDiffable>,
        cellForViewModel viewModel: Any, at index: Int
        ) -> UICollectionViewCell & ListBindable {
        
        guard let cell = collectionContext?.dequeueReusableCell(of: NewsCell.self, for: self, at: index) as? NewsCell else { fatalError() }
        return cell
    }
    
    func sectionController(
        _ sectionController: ListBindingSectionController<ListDiffable>,
        sizeForViewModel viewModel: Any, at index: Int
        ) -> CGSize {
        
        guard let width = collectionContext?.containerSize.width else { fatalError() }
        
        return CGSize(width: width, height: NewsCell.designedHeight)
    }
}
