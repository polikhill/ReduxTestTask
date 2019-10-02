//
//  RxSwiftExtensions.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/2/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    func voidValues() -> Observable<Void> {
        return map { _ in () }
    }
    
    func observeForUI() -> Observable<E> {
        return observeOn(MainScheduler.instance)
    }
}
