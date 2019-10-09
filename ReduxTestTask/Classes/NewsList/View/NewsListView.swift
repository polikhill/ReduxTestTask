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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
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
            DispatchQueue.main.async {
                self.loader.startAnimating()
            }
        } else {
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func render(_ props: ContentViewProps) {
        if props.isLoading != renderedProps?.isLoading {
            toggleLoading(on: props.isLoading)
        }
        
        renderedProps = props
    }
}

extension Reactive where Base: NewsListView {    
    var pullToRefresh: Observable<Void> {
        return base.refreshControl.rx.controlEvent(.valueChanged).asObservable()
    }
}
