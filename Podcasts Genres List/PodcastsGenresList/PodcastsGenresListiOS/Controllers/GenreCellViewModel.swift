// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public struct GenreCellViewModel: Hashable {
    let name: String
    let color: UIColor
    
    public init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
}
