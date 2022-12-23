// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import HTTPClient

final class SearchCoordinator {
    private let navigationController: UINavigationController
    private let baseURL: URL
    private let httpClient: HTTPClient
        
    init(navigationController: UINavigationController,
         baseURL: URL,
         httpClient: HTTPClient) {
        self.navigationController = navigationController
        self.baseURL = baseURL
        self.httpClient = httpClient
    }
        
    func start() {
        navigationController.setViewControllers([createGenres()], animated: false)
    }
    
    private func show(screen: UIViewController) {
        self.navigationController.pushViewController(screen, animated: true)
    }
    
    private func present(screen: UIViewController) {
        self.navigationController.showDetailViewController(screen, sender: self)
    }
    
    private func createGenres() -> UIViewController {
        UIViewController()
    }
}
