// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol ImageDataLoaderTask {
    func cancel()
}

public protocol ImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    @discardableResult
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> ImageDataLoaderTask
}
