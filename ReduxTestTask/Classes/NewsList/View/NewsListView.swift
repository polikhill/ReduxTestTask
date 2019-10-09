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
    
    struct ContentViewProps {
        let isLoading: Bool
        let items: [DiffableBox<NewsCell.Props>]
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let loader = UIActivityIndicatorView(style: .gray)
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate let tableView = UITableView()
    private let items = PublishSubject<[NewsCell.Props]>()
    private let disposeBag = DisposeBag()
    private var renderedProps: ContentViewProps?
    fileprivate let willDisplayCellAt = PublishSubject<Int>()
    fileprivate let itemSelectedAt = PublishSubject<Int>()
    
    private lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: nil)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        collectionView.refreshControl = refreshControl
        collectionView.register(cellType: NewsCell.self)
        collectionView.backgroundColor = .white
        
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
        collectionLayout.minimumInteritemSpacing = NewsCell.spaceBetweeenCells
        collectionLayout.minimumLineSpacing = NewsCell.spaceBetweeenCells
        collectionView.collectionViewLayout = collectionLayout
    }
    
    private func setupLoader() {
        loader.isHidden = true
        loader.hidesWhenStopped = true
        addSubview(loader)
        loader.center = center
    }
    
    private func toggleLoading(on: Bool) {
        if on {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
            refreshControl.endRefreshing()
        }
    }
    
    func render(_ props: ContentViewProps) {
        if props.isLoading != renderedProps?.isLoading {
            toggleLoading(on: props.isLoading)
        }
        
        renderedProps = props
        adapter.performUpdates(animated: true)
    }
}

extension NewsListView: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return renderedProps?.items ?? []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let newslistController = NewsListController()
        newslistController.itemSelectedAt
            .bind(to: itemSelectedAt)
            .disposed(by: disposeBag)
        
        return newslistController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension NewsListView: IGListAdapterDelegate {
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        willDisplayCellAt.onNext(index)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) { }
}

extension Reactive where Base: NewsListView {    
    var pullToRefresh: Observable<Void> {
        return base.refreshControl.rx.controlEvent(.valueChanged).asObservable()
    }
    var cellSelected: Observable<Int> {
        return base.itemSelectedAt.asObservable()
    }
    var willDisplayCell: Observable<Int> {
        return base.willDisplayCellAt.asObservable()
    }
}
