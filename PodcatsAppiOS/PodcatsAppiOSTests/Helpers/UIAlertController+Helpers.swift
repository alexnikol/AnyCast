// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

extension UIAlertController {
    
    typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
    
    func tapButtonAtIndex(index: Int) {
        let alertAction = actions[index]
        let block = alertAction.value(forKey: "handler")
        let handler = unsafeBitCast(block as AnyObject, to: AlertHandler.self)
        handler(alertAction)
    }
}
