//
//  NewsListFetchMiddleware.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/2/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import RxSwift

extension NewsList {
    static func makeFetchNewsMiddleware(newsService: NewsServiceProtocol) -> Store.Middleware {
        let disposeBag = DisposeBag()
        
        return Store.makeMiddleware { dispatch, _, next, action in
            next(action)
            
            guard action is LoadNews else {
                return
            }
            
            let info = NewsNetworkInfo(page: 1)
            
            newsService.getNews(info: info)
                .map({ data -> Action in
                    switch data {
                    case .success(let object):
                        guard let news = object as? [Article] else {
                            return LoadNewsError(error: ParseError.parsingError)
                        }
                        return LoadNewsSuccess(news: news)
                    case .failure(let message):
                        return LoadNewsError(error: message)
                    }
                })
                .catchError { error in Observable.just(LoadNewsError(error: error)) }
                .subscribe(onNext: dispatch)
                .disposed(by: disposeBag)
        }
    }
    
    static func makeLoadNextPageMiddleware(newsService: NewsServiceProtocol) -> Store.Middleware {
        let disposeBag = DisposeBag()
        
        return Store.makeMiddleware { dispatch, getStore, next, action in
            next(action)
            let store = getStore()
            
            guard
                let action = action as? LoadNextPage,
                action.row == store.fetchedNews.count - 2 else {
                    return
            }
            
            let info = NewsNetworkInfo(page: store.page)
            
            newsService.getNews(info: info)
                .flatMap({ data -> Observable<Action> in
                    switch data {
                    case .success(let object):
                        guard let news = object as? [Article] else {
                            return Observable.just(LoadNewsError(error: ParseError.parsingError))
                        }
                        guard !news.isEmpty else {
                            return Observable.empty()
                        }
                        return Observable.just(LoadNewsSuccess(news: news))
                    case .failure(let message):
                        return Observable.just(LoadNewsError(error: message))
                    }
                })
                .catchError { error in Observable.just(LoadNewsError(error: error)) }
                .subscribe(onNext: dispatch)
                .disposed(by: disposeBag)
        }
    }
    
    static func makeShowArticleMiddleware(showArticle: PublishSubject<Article>) -> Store.Middleware {
        let disposeBag = DisposeBag()
        
        return Store.makeMiddleware { dispatch, getStore, next, action in
            next(action)
            let store = getStore()
            
            guard
                let action = action as? SelectedCell else {
                    return
            }
            
            let article = store.fetchedNews[action.index]
            
            Observable
                .just(article)
                .do(onNext: { _ in showArticle.onNext(article) })
                .map ({ article -> Action in
                    return ShowArticle(article: article)
                })
                .subscribe(onNext: dispatch)
                .disposed(by: disposeBag)
        }
    }
}
