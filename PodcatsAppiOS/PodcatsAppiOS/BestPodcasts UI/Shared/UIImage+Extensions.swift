// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

extension UIImage {
    struct InvalidImageData: Error {}
    
    static func trytoMake(with data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw InvalidImageData()
        }
        return image
    }
}
