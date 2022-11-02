// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public final class BestPodcastsPresenter {
    
    public static func map(_ model: BestPodcastsList) -> BestPodcastsPresenterViewModel {
        .init(title: model.genreName, podcasts: model.podcasts.map(Self.map))
    }
    
    private static func map(_ model: Podcast) -> PodcastImageViewModel {
        .init(
            title: model.title,
            publisher: model.publisher,
            languageStaticLabel: "Language:",
            languageValueLabel: model.language,
            typeStaticLabel: "Type:",
            typeValueLabel: String(describing: model.type),
            image: model.image
        )
    }
}
