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
        }
        
        struct Outputs {
            let props: Observable<NewsListController.Props>
            let stateChanged: Observable<Void>
        }
        
        private let service: NewsServiceProtocol
        
        init(service: NewsServiceProtocol) {
            self.service = service
        }
        
        func makeOutputs(from inputs: Inputs) -> Outputs {
            let initialState = State(
                fetchedNews: [],
                isLoading: false,
                error: nil
            )
            
            let fetchMiddleware = NewsList.makeFetchNewsMiddleware(newsService: service)
            
            let store = Store(initialState: initialState, reducer: NewsList.reduce, middlewares: [
                fetchMiddleware
                ])
            
            let props = store.state
            .map(NewsList.makeProps)
            
            let actionCreator = ActionCreator(inputs: inputs, newsService: service)
            
            let stateChanges = actionCreator.actions
            .do(onNext: store.dispatch)
            .voidValues()
            
            return Outputs(
                props: props,
                stateChanged: stateChanges
            )
        }
    }
}
