//
//  NewsListStore.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/2/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation

extension NewsList {
    typealias Store = ReduxStore<State, Action>
    
    struct State {
        var fetchedNews: [Article]
        var isLoading: Bool
        var error: Error?
    }
    
    struct LoadNews: Action { }
    
    struct LoadNewsSuccess: Action {
        let news: [Article]
    }
    
    struct LoadNewsError: Action {
        let error: Error
    }
    
    struct DismissError: Action { }
    
    static func reduce(state: State, action: Action) -> State {
        var newState = state
        
        switch action {
        case is LoadNews:
            newState.isLoading = true
            
        case let action as LoadNewsSuccess:
            newState.fetchedNews = action.news
            newState.isLoading = false
            
        case let action as LoadNewsError:
            newState.error = action.error
            newState.isLoading = false
            
        case is DismissError:
            newState.error = nil
            
        default:
            fatalError("New Action was added.")
        }
        
        return newState
    }
}
