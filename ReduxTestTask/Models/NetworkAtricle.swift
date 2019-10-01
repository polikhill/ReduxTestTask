//
//  NetworkAtricle.swift
//  TestTask
//
//  Created by Polina on 8/18/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import Foundation

struct NetworkResponse: Decodable {
    let status: String
    let articles: [NetworkArticle]
}
struct NetworkArticle: Decodable {
    let author: String?
    let title: String
    let description: String?
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}
