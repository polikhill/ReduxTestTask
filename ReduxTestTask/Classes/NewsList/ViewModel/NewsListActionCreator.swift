//
//  NewsListActionCreator.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/2/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import RxSwift

extension NewsList {
    
    final class ActionCreator {
        let actions: Observable<Action>
        
        init(inputs: NewsListViewModel.Inputs, newsService: NewsServiceProtocol) {
            let dismissErrorAction = inputs.dismissError
                .map ({ _ -> Action in
                    return DismissError()
                })
            
            self.actions = dismissErrorAction
        }
    }
}
