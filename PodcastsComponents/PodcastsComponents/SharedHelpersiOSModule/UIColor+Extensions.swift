// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public extension UIColor {
    static var tintColor: UIColor {
        get {
            return UIApplication.shared.windows.first?.rootViewController?.view.tintColor ?? .clear
        }
    }
}
