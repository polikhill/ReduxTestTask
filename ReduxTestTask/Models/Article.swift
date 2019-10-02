//
//  News.swift
//  TestTask
//
//  Created by Polina on 8/18/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import Foundation

struct Article {
    let author: String
    let title: String
    let description: String
    let image: URL?
    let publishDate: Date
    let content: String?
}

extension Article {
    init?(from networkArticle: NetworkArticle) {
        self.init(
            author: networkArticle.author ?? "",
            title: networkArticle.title,
            description: networkArticle.description ?? "",
            image: URL(string: networkArticle.urlToImage ?? ""),
            publishDate: Date(),
            content: networkArticle.content
        )
    }
}
