// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public class ThumbnailView: NibView {
    @IBOutlet private(set) weak var imageMainContainer: UIView!
    @IBOutlet private(set) weak var imageInnerContainer: UIView!
    @IBOutlet private(set) weak var imageView: UIImageView!
    
    public override func setupView() {
        imageInnerContainer.layer.cornerRadius = 4.0
        imageMainContainer.layer.cornerRadius = 4.0
        imageMainContainer.layer.shadowColor = UIColor.accentColor.cgColor
        imageMainContainer.layer.shadowOpacity = 0.5
        imageMainContainer.layer.shadowOffset = .zero
        imageMainContainer.layer.shadowRadius = 10.0
    }
}
