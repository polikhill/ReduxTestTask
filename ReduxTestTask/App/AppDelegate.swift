//
//  AppDelegate.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/1/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        let newsService = NewsService()
        
        showApp(service: newsService)
        
        return true
    }
}

extension AppDelegate {
    private func showApp(service: NewsServiceProtocol) {
        let newsController = NewsListController(service: service)
        let newsNavigationNavController = UINavigationController(rootViewController: newsController)
        self.window?.rootViewController = newsNavigationNavController
    }
}

