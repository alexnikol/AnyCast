// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public class DefaultImageView: NibView {
    @IBOutlet public private(set) weak var imageMainContainer: UIView!
    @IBOutlet public private(set) weak var imageInnerContainer: UIView!
    @IBOutlet public weak var imageView: UIImageView!
    
    public override func setupView() {
        imageInnerContainer.layer.cornerRadius = 4.0
        imageMainContainer.layer.cornerRadius = 4.0
        imageView.clipsToBounds = true
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
