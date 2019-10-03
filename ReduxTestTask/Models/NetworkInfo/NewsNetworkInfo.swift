//
//  NewsNetworkInfo.swift
//  TestTask
//
//  Created by Polina on 8/18/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import Foundation

struct NewsNetworkInfo {
    let page: Int

    var json: [String: Any] {
        return [
            "page": page,
            "pageSize": 10,
            "country": "us"
        ]
    }

    var header: [String: String] {
        return [
            "X-Api-Key": AppConstants.ApiKey
        ]
    }
}
