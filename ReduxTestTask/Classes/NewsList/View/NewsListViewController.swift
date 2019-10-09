//
//  NewsListViewController.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/1/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit
import RxSwift

final class NewsListViewController: UIViewController {

    struct Props {
        let contentViewProps: NewsListView.ContentViewProps
        let error: String?
    }
    
    private lazy var contentView = NewsListView()
    private let viewModel: NewsList.NewsListViewModel
    private let errorPresenter = ErrorPresenter()
    private var renderedProps: Props?
    private let disposedBag = DisposeBag()
    
    init(service: NewsServiceProtocol) {
        viewModel = NewsList.NewsListViewModel(service: service)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindigns()
    }
    
    private func setupBindigns() {
        let inputs = NewsList.NewsListViewModel.Inputs(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear(_:))).voidValues(),
            pullToRefresh: contentView.rx.pullToRefresh,
            dismissError: errorPresenter.dismissed,
            willDisplayCellAt: contentView.rx.willDisplayCell,
            cellSelectedAt: contentView.rx.cellSelected
        )
        
        let outputs = viewModel.makeOutputs(from: inputs)
        
        outputs.props
        .observeForUI()
            .subscribe(onNext: { [unowned self ] props in
                self.render(props: props)
            })
        .disposed(by: disposedBag)
        
        outputs.showArticle
            .observeForUI()
            .subscribe(onNext: { [unowned self ] article in
                self.showArticle(article)
            })
            .disposed(by: disposedBag)
        
        outputs.stateChanged
        .subscribe()
        .disposed(by: disposedBag)
    }
    
    private func render(props: Props) {
        contentView.render(props.contentViewProps)
        
        if let error = props.error, renderedProps?.error != error {
            errorPresenter.present(error: error, on: self)
        }
        
        renderedProps = props
    }
    
    private func showArticle(_ article: Article) {
        let articleController = ArticleController(article: article)
        navigationController?.pushViewController(articleController, animated: true)
    }
}
