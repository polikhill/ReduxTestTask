//
//  ApiResponse.swift
//  TestTask
//
//  Created by Polina on 8/18/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import Foundation
import Moya

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
    static func parse(response: Response) -> Result<[Article], Error> {

        switch response.statusCode {
        case 200..<300:
            do {
                let model: NetworkArticleResponse = try response.map(NetworkArticleResponse.self)
                return .success(model.articles.compactMap(Article.init))
            }
            catch {
                return .failure(error)
            }
        default:
            do {
                let json = try response.mapJSON()
                guard let dict = json as? [String: Any],
                    let message = dict["message"] as? String
                    else { throw ParseError.parsingError }
                return .failure(ParseError.error(message))
            }
            catch {
                return .failure(error)
            }
        }
    }
}
