//
//  NewsListViewModel.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/2/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import RxSwift

extension NewsList {
    
    final class NewsListViewModel {
        
        struct Inputs {
            let viewWillAppear: Observable<Void>
            let pullToRefresh: Observable<Void>
            let dismissError: Observable<Void>
            let willDisplayCellAt: Observable<Int>
            let cellSelectedAt: Observable<Int>
        }
        
        struct Outputs {
            let props: Observable<NewsParentController.Props>
            let stateChanged: Observable<Void>
            let showArticle: Observable<Article>
        }
        
        private let service: NewsServiceProtocol
        
        init(service: NewsServiceProtocol) {
            self.service = service
        }
        
        func makeOutputs(from inputs: Inputs) -> Outputs {
            let selectedArticle = PublishSubject<Article>()
            
            let initialState = State(
                fetchedNews: [],
                page: 1,
                isLoading: false,
                error: nil
            )
            
            let fetchMiddleware = NewsList.makeFetchNewsMiddleware(newsService: service)
            let loadNextPageMiddleware = NewsList.makeLoadNextPageMiddleware(newsService: service)
            let getSelectedArticleMiddleware = NewsList.makeShowArticleMiddleware(showArticle: selectedArticle)
            
            let store = Store(initialState: initialState, reducer: NewsList.reduce, middlewares: [
                fetchMiddleware,
                loadNextPageMiddleware,
                getSelectedArticleMiddleware
                ])
            
            let props = store.state
                .map(NewsList.makeProps)
            
            let actionCreator = ActionCreator(inputs: inputs)
            
            let stateChanges = actionCreator.actions
                .do(onNext: store.dispatch)
                .voidValues()
            
            return Outputs(
                props: props,
                stateChanged: stateChanges,
                showArticle: selectedArticle.asObservable()
            )
        }
    }
}
