//
//  PodcastsGenresLoader.swift
//  PodcastsGenresList
//
//  Created by Alexander Nikolaychuk on 31.08.2022.
//

import Foundation

struct Genre {
    let id: Int
    let name: String
}

protocol GenresLoader {
    func load(completion: Result<[Genre], Error>)
}
