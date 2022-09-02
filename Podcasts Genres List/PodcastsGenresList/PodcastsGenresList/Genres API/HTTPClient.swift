// Copyright © 2022 Almost Engineer. All rights reserved. 

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
