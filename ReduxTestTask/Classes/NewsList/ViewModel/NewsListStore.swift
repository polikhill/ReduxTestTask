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
        var page: Int
        var isLoading: Bool
        var error: Error?
    }
    
    struct LoadNews: Action { }
    
    struct LoadNextPage: Action {
        let row: Int
    }
    
    struct LoadNewsSuccess: Action {
        let news: [Article]
    }
    
    struct LoadNewsError: Action {
        let error: Error
    }
    
    struct SelectedCell: Action {
        let index: Int
    }
    
    struct ShowArticle: Action {
        let article: Article?
    }
    
    struct DismissError: Action { }
    
    static func reduce(state: State, action: Action) -> State {
        var newState = state
        
        switch action {
        case is LoadNews:
            newState.isLoading = true
            newState.page = 1
            newState.fetchedNews = []
            
        case is LoadNextPage:
            newState.isLoading = true
            
        case let action as LoadNewsSuccess:
            newState.fetchedNews.append(contentsOf: action.news)
            newState.isLoading = false
            newState.page += 1
            
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
