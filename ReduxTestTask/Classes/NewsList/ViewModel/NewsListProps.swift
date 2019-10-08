//
//  NewsListProps.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/2/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation

extension NewsList {
    
    static func makeProps(from state: State) -> NewsListViewController.Props {
        func makeNewsCellProps(from article: Article) -> NewsCell.Props {
            return NewsCell.Props(
                title: article.author,
                subtitle: article.title,
                date: DateFormatter.shortTime.string(from: article.publishDate),
                backgroundImageURL: article.image
            )
        }
        return NewsListViewController.Props(
            items: state.fetchedNews.compactMap { makeNewsCellProps(from: $0) },
            error: state.error?.localizedDescription,
            isLoading: state.isLoading
        )
    }
}
