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
}
