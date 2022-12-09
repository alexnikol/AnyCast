// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule

public final class PodcastHeaderReusableView: UITableViewHeaderFooterView, Reusable {
        
    @IBOutlet public private(set) weak var titleLabel: UILabel!
    @IBOutlet public private(set) weak var authorLabel: UILabel!
    @IBOutlet private weak var mainContainer: UIView!
    @IBOutlet public private(set) weak var imageView: ThumbnailView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        mainContainer.layer.cornerRadius = 4.0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
