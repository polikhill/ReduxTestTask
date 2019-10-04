//
//  NewsListView.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/1/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import IGListKit

final class NewsListView: UIView {

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    fileprivate let refreshControl = UIRefreshControl()
    private let items = PublishSubject<[NewsCell.Props]>()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        collectionView.addSubview(refreshControl)
//        collectionView.register(cellType: NewsCell.self)
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.estimatedItemSize = CGSize(width: collectionView.frame.width, height: NewsCell.designedHeight)
        collectionView.collectionViewLayout = collectionLayout
    }
    
    func setItems(_ props: [NewsCell.Props]) {
        items.onNext(props)
    }
    
    func toggleLoading(on: Bool) {
        if on {
            refreshControl.beginRefreshing()
        } else {
            refreshControl.endRefreshing()
        }
    }
}

extension Reactive where Base: NewsListView {    
    var pullToRefresh: Observable<Void> {
        return base.refreshControl.rx.controlEvent(.valueChanged).asObservable()
    }
    
    var willDisplayCell: Observable<Int> {
        return base.collectionView.rx.willDisplayCell.asObservable().map({$0.at.row})
    }
    
    var cellSelected: Observable<Int> {
        return base.collectionView.rx.itemSelected.asObservable().map({$0.row})
    }
}
