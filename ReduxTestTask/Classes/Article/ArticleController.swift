//
//  ArticleController.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/3/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit

final class ArticleController: UIViewController {

    private lazy var contentView = ArticleView.initFromNib()
    
    init(article: Article) {
        super.init(nibName: nil, bundle: nil)
        contentView.render(props: makeArticleProps(from: article))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
}

func makeArticleProps(from article: Article) -> ArticleView.Props {
    return ArticleView.Props(
        title: article.author,
        subtitle: article.title,
        date: DateFormatter.shortTime.string(from: article.publishDate)
    )
}
