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
    case failure(error: Error)
}

enum ParseError: Error {
    case parsingError
    case error(String)

    var localizedDescription: String {
        switch self {
        case .parsingError:  return ErrorStrings.parsingError
        case .error(let message): return message
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
                return ApiResponse.failure(error: error)
            }
        default:
            do {
                let json = try response.mapJSON()
                guard let dict = json as? [String: Any],
                    let message = dict["message"] as? String
                    else { throw ParseError.parsingError }
                return ApiResponse.failure(error: ParseError.error(message))
            }
            catch {
                return ApiResponse.failure(error: error)
            }
        }
    }
}
