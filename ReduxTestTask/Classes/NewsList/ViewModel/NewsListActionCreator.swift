//
//  NewsListActionCreator.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/2/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import RxSwift

extension NewsList {
    
    final class ActionCreator {
        let actions: Observable<Action>
        
        init(inputs: NewsListViewModel.Inputs, newsService: NewsServiceProtocol) {
            let dismissErrorAction = inputs.dismissError
                .map ({ _ -> Action in
                    return DismissError()
                })
            
            let loadNewsAction = Observable.merge(
                inputs.pullToRefresh,
                inputs.viewWillAppear.take(1)
            )
                .map ({ _ -> Action in
                    return LoadNews()
                })
            
            let loadNextPageAction = inputs.willDisplayCellAt
                .map ({ row -> Action in
                    return LoadNextPage(row: row)
                })
            
            let selectCellAction = inputs.cellSelectedAt
                .map ({ row -> Action in
                    return SelectedCell(index: row)
                })
            
            self.actions = Observable.merge(
            loadNewsAction,
            dismissErrorAction,
            loadNextPageAction,
            selectCellAction
            )
        }
    }
}
