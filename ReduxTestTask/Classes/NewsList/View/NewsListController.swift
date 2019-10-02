//
//  NewsListController.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/1/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit
import RxSwift

final class NewsListController: UIViewController {

    struct Props {
        let items: [NewsCell.Props]
        let error: String?
        let isLoading: Bool
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
            dismissError: errorPresenter.dismissed
        )
        
        let outputs = viewModel.makeOutputs(from: inputs)
        
        outputs.props
        .observeForUI()
            .subscribe(onNext: { [unowned self ] props in
                self.render(props: props)
            })
        .disposed(by: disposedBag)
        
        outputs.stateChanged
        .subscribe()
        .disposed(by: disposedBag)
    }
    
    private func render(props: Props) {
        if renderedProps?.items != props.items {
            contentView.setItems(props.items)
        }
        
        if renderedProps?.isLoading != props.isLoading {
            contentView.toggleLoading(on: props.isLoading)
        }
        
        if let error = props.error, renderedProps?.error != error {
            errorPresenter.present(error: error, on: self)
        }
        
        renderedProps = props
    }
}
