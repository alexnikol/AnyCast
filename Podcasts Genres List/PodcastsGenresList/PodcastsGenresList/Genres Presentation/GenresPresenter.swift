// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public class GenresPresenter {
    public static var title: String {
        return NSLocalizedString(
            "GENRES_VIEW_TITLE",
             tableName: "Genres",
             bundle: .init(for: Self.self),
             comment: "Title for the genres view"
        )
    }
        
    public static func map(_ genres: [Genre]) -> GenresViewModel {
        return GenresViewModel(genres: genres)
    }
}
