// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

func uniqueGenres() -> (models: [Genre], local: [LocalGenre]) {
    let models: [Genre] = [
        .init(id: 1, name: "any genre"),
        .init(id: 2, name: "another genre"),
    ]
    
    let local = models.map { LocalGenre(id: $0.id, name: $0.name) }
    
    return (models: models, local: local)
}

func uniqueGenre(id: Int) -> Genre {
    .init(id: id, name: "any genre")
}

extension Date {
    
    func minusGenreCacheMaxAge() -> Date {
        return adding(days: -7)
    }
    
    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }

    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
