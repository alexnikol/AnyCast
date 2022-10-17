// Copyright © 2022 Almost Engineer. All rights reserved. 

import Foundation

public typealias GenresLoaderResult = Swift.Result<[Genre], Error>

public protocol GenresLoader {
    func load(completion: @escaping (GenresLoaderResult) -> Void)
}
