// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel
    
    func display(_ viewModel: ResourceViewModel)
}
