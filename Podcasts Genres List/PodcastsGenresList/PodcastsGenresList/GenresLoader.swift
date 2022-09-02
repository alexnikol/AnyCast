// Copyright © 2022 Almost Engineer. All rights reserved. 

import Foundation

protocol GenresLoader {
    func load(completion: @escaping (Result<[Genre], Error>) -> Void)
}
