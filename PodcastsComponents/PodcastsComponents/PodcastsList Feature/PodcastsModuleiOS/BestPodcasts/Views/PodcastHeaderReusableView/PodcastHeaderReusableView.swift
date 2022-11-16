// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule

public final class PodcastHeaderReusableView: UITableViewHeaderFooterView, Reusable {
        
    @IBOutlet public private(set) weak var titleLabel: UILabel!
    @IBOutlet public private(set) weak var authorLabel: UILabel!
    @IBOutlet public private(set) weak var imageMainContainer: UIView!
    @IBOutlet public private(set) weak var imageInnerContainer: UIView!
    @IBOutlet public private(set) weak var imageView: UIImageView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        imageInnerContainer.layer.cornerRadius = 4.0
        imageMainContainer.layer.cornerRadius = 4.0
        imageMainContainer.layer.shadowColor = UIColor.tintColor.cgColor
        imageMainContainer.layer.shadowOpacity = 0.3
        imageMainContainer.layer.shadowOffset = .zero
        imageMainContainer.layer.shadowRadius = 8.0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
