//
//  NewsListViewModel.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/2/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import RxSwift

extension NewsList {
    
    final class NewsListViewModel {
        
        struct Inputs {
            let viewWillAppear: Observable<Void>
            let refresh: Observable<Void>
        }
        
        struct Outputs {
            let props: Observable<NewsListController.Props>
            let stateChanged: Observable<Void>
        }
        
        private let service: NewsServiceProtocol
        
        init(service: NewsServiceProtocol) {
            self.service = service
        }
        
        func makeOutputs(from inputs: Inputs) {
            let initialState = State(
                fetchedNews: [],
                isLoading: false,
                error: nil
            )
            
        }
    }
    
}
