// Copyright © 2022 Almost Engineer. All rights reserved. 

import Foundation

public typealias LoadGenresResult = Result<[Genre], Error>

public protocol GenresLoader {
    func load(completion: @escaping (LoadGenresResult) -> Void)
}
