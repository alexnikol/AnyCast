// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

protocol RootStickyPlayerView {
    func hideStickyPlayer()
    func showStickyPlayer()
}

class RootTabBarPresenter {
    var view: RootStickyPlayerView?
        
    var exploreTabBarItemTitle: String {
        return NSLocalizedString(
            "EXPLORE_TABBAR_ITEM_TITLE",
             tableName: "Main",
             bundle: .init(for: Self.self),
             comment: "Title for the explore tab bar item"
        )
    }
    
    func showStickyPlayer() {
        view?.showStickyPlayer()
    }
    
    func hideStickyPlayer() {
        view?.hideStickyPlayer()
    }
}
