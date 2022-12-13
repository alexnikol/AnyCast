// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

class RootTabBarControllerPresenter {
    private init() {}
    
    public static var exploreTabBarItemTitle: String {
        return NSLocalizedString(
            "EXPLORE_TABBAR_ITEM_TITLE",
             tableName: "Main",
             bundle: .init(for: Self.self),
             comment: "Title for the explore tab bar item"
        )
    }
}
