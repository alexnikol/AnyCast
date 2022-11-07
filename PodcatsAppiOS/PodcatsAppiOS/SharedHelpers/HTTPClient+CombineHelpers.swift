// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import HTTPClient
import Combine

public extension HTTPClient {
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>
    
    func loadPublisher(from url: URL) -> Publisher {
        Deferred {
            Future { completion in
                self.get(from: url, completion: completion)
            }
        }.eraseToAnyPublisher()
    }
}
