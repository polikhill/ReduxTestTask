//
//  ApiResponse.swift
//  TestTask
//
//  Created by Polina on 8/18/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import Foundation
import Moya

enum ApiResponse {
    case success(object: Any)
    case failure(message: String)
}

enum ParseError: Error {
    case parsingError

    var localizedDescription: String {
        switch self {
        case .parsingError:  return ErrorStrings.parsingError
        }
    }
}

struct ApiParseResult {
    static func parse(response: Response) -> ApiResponse {

        switch response.statusCode {
        case 200..<300:
            do {
                let model: NetworkResponse = try response.map(NetworkResponse.self)
                return ApiResponse.success(object: model.articles.compactMap(Article.init))
            }
            catch {
                return ApiResponse.failure(message: error.localizedDescription)
            }
        default:
            do {
                let json = try response.mapJSON()
                guard let dict = json as? [String: Any],
                    let message = dict["message"] as? String
                    else { throw ParseError.parsingError }
                return ApiResponse.failure(message: message)
            }
            catch {
                return ApiResponse.failure(message: error.localizedDescription)
            }
        }
    }
}
