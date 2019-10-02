//
//  NewsListController.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/1/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit

final class NewsListController: UIViewController {

    struct Props {
        let items: [NewsCell.Props]
        let error: Error?
        let isLoading: Bool
    }
    
    private lazy var contentView = NewsListView()
    
    override func loadView() {
        view = contentView
    }
}
