//
//  GenresLoader.swift
//  GenresLoader
//
//  Created by Alexander Nikolaychuk on 31.08.2022.
//

import Foundation

protocol GenresLoader {
    func load(completion: @escaping (Result<[Genre], Error>) -> Void)
}
