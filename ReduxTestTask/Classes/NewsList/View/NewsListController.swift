//
//  NewsListController.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/4/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit
import IGListKit
import RxSwift

final class NewsListController: ListBindingSectionController<DiffableBox<NewsCell.Props>>, ListBindingSectionControllerDataSource {
   
    let itemSelectedAt = PublishSubject<Int>()
    
    override init() {
        super.init()
        dataSource = self
        selectionDelegate = self
    }
}

extension NewsListController {
    func sectionController(
        _ sectionController: ListBindingSectionController<ListDiffable>,
        viewModelsFor object: Any
        ) -> [ListDiffable] {
        
        guard let props = object as? DiffableBox<NewsCell.Props> else { return [] }
        let diffableNews: [ListDiffable] = [props]
        
        return diffableNews
    }
    
    func sectionController(
        _ sectionController: ListBindingSectionController<ListDiffable>,
        cellForViewModel viewModel: Any, at index: Int
        ) -> UICollectionViewCell & ListBindable {
        
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: "\(NewsCell.self)", bundle: nil, for: self, at: index) as? NewsCell else { fatalError() }
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

extension NewsListController: ListBindingSectionControllerSelectionDelegate {
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didSelectItemAt index: Int, viewModel: Any) {
        itemSelectedAt.onNext(sectionController.section)
    }
}
