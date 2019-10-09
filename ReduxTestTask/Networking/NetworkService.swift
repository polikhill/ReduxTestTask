//
//  NetworkService.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/1/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import Foundation
import RxMoya
import Moya
import RxSwift

enum NewsAPI {
    case getNews(info: NewsNetworkInfo)
}

extension NewsAPI: TargetType {

    var baseURL: URL {
        return AppConstants.baseURL
    }

    var path: String {
        switch self {
        case .getNews: return "v2/top-headlines"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getNews(let info):
            return Task.requestParameters(parameters: info.json, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getNews(let info):
            return info.header
        }
    }
}

protocol NewsServiceProtocol {
    func getNews(page: Int) -> Observable<Result<[Article], Error>>
}

final class NewsService: NewsServiceProtocol {

    private let provider = MoyaProvider<NewsAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])

    func getNews(page: Int) -> Observable<Result<[Article], Error>> {
        return provider.rx.request(.getNews(info: NewsNetworkInfo(page: page)))
            .map({ genericResponse -> Result<[Article], Error> in
                return ApiParseResult.parse(response: genericResponse)
            })
            .asObservable()

    }
}

