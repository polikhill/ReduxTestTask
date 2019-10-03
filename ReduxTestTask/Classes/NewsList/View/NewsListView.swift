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

final class NewsListView: UIView {

    fileprivate let tableView = UITableView()
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
        tableView.addSubview(refreshControl)
        tableView.register(NewsCell.self)
        tableView.rowHeight = NewsCell.designedHeight
        tableView.estimatedRowHeight = NewsCell.designedHeight
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: NewsCell.identifier, cellType: NewsCell.self)) { _, model, cell in
                cell.render(props: model)
            }
            .disposed(by: disposeBag)
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
        return base.tableView.rx.willDisplayCell.asObservable().map({$0.indexPath.row})
    }
    
    var cellSelected: Observable<Int> {
        return base.tableView.rx.itemSelected.asObservable().map({$0.row})
    }
}
