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
        return NewsListViewController.Props(
            contentViewProps: NewsListView.ContentViewProps(
                isLoading: state.isLoading,
                items: state.fetchedNews.compactMap { makeNewsCellDiffableProps(from: $0) }),
            error: state.error?.localizedDescription
        )
    }
    
    static private func makeNewsCellDiffableProps(from article: Article) -> DiffableBox<NewsCell.Props> {
        let cellProps = NewsCell.Props(
            title: article.author,
            subtitle: article.title,
            date: DateFormatter.shortTime.string(from: article.publishDate),
            backgroundImageURL: article.image
        )
        return DiffableBox(value: cellProps, identifier: cellProps.diffIdentifier as NSObjectProtocol, equal: ==)
    }
}
