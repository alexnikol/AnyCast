// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol GenresCache {
    typealias SaveResult = Error?
    func save(_ genres: [Genre], completion: @escaping (SaveResult) -> Void)
}
