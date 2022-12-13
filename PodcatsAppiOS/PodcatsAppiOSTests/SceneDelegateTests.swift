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
        let rootNavigation = root as? UITabBarController
        let rootFirstTabNavigation = rootNavigation?.viewControllers?.first as? UINavigationController
        let topFirstTabController = rootFirstTabNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Expected a tab bar controller as root, got \(String(describing: root)) instead")
        XCTAssertNotNil(rootFirstTabNavigation, "Expected a navigation controller as root for first tab in the root tab bar controller, got \(String(describing: rootFirstTabNavigation)) instead")
        XCTAssertTrue(topFirstTabController is GenresListViewController, "Expected genres controller as top view controller in first tab stack, got \(String(describing: topFirstTabController)) instead")
    }
    
    func test_configureWindow_rendrersTitlesOfScreens() {
        let sut = SceneDelegate()
        sut.window = UIWindow()
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UITabBarController
        let rootFirstTabNavigation = rootNavigation?.viewControllers?.first as? UINavigationController
        let rootFirstTabNavigationTabBarTitle = rootFirstTabNavigation?.tabBarItem.title
        
        XCTAssertEqual(rootFirstTabNavigationTabBarTitle, "Explore")
    }
}
