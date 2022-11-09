// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule
import PodcastsGenresListiOS
@testable import Podcats

class SceneDelegateTests: XCTestCase {
    
    func test_configureWindow_setsWindowAsKeyAndVisible() {
        let window = UIWindow()
        let sut = SceneDelegate()
        sut.window = window
        window.windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        sut.configureWindow()
        
        XCTAssertTrue(window.isKeyWindow, "Expected window to be the key window")
        XCTAssertFalse(window.isHidden, "Expected window to be visible")
    }
    
    func test_configureWindow_configureRootViewCotroller() {
        let sut = SceneDelegate()
        sut.window = UIWindow()
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is GenresListViewController, "Expected genres controller as top view controller, got \(String(describing: topController)) instead")
    }
}
