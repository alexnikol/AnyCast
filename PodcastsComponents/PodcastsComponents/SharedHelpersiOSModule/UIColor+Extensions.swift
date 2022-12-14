// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public extension UIColor {
    static var accentColor: UIColor {
        get {
            if #available(iOS 15.0, *) {
                return UIColor.tintColor
            } else {
                return UIApplication.shared.windows.first?.rootViewController?.view.tintColor ?? .clear
            }
        }
    }
}
