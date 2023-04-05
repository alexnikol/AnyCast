// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public class DefaultImageView: NibView {
    @IBOutlet public private(set) weak var imageMainContainer: UIView!
    @IBOutlet public private(set) weak var imageInnerContainer: UIView!
    @IBOutlet public weak var imageView: UIImageView!
    
    public override func setupView() {
        imageView.clipsToBounds = true
    }
    
    public func setCornerRadius(_ value: CGFloat) {
        imageInnerContainer.layer.cornerRadius = value
        imageMainContainer.layer.cornerRadius = value
    }
}

extension DefaultImageView: AsyncImageView {

    public var rootImage: UIImageView? {
        imageView
    }
    
    public var shimmeringContainer: UIView? {
        imageInnerContainer
    }
}
