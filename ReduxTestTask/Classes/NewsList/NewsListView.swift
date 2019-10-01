//
//  NewsListView.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/1/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit
import RxSwift

final class NewsListView: UIView {

    private let tableView = UITableView()
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
//            items
//            .bind(to: tableView.rx.items(cellIdentifier: NewsCell.identifier, cellType: NewsCell.self)) { row, model, cell in
//                cell.configre(with: model)
//            }
//            .disposed(by: disposeBag)
        
    }
}
