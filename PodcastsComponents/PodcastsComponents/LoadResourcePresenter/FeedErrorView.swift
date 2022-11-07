// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct ResourceErrorViewModel {
    public let message: String?
    
    public init(message: String?) {
        self.message = message
    }
    
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }
    
    static func errorMesssage(_ message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}

public protocol ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel)
}
