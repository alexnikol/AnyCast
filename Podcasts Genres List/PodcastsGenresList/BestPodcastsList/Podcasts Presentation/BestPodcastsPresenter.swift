// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public final class BestPodcastsPresenter {
    
    public static func map(_ model: BestPodcastsList) -> BestPodcastsPresenterViewModel {
        .init(title: model.genreName, podcasts: model.podcasts)
    }
}
