// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

protocol NibReusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension NibReusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
