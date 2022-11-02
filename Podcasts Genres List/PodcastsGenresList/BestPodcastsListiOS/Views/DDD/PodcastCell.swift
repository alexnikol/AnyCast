// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public final class PodcastCell: UITableViewCell, NibReusable {
    @IBOutlet public private(set) weak var titleLabel: UILabel!
    @IBOutlet public private(set) weak var publisherLabel: UILabel!
    @IBOutlet public private(set) weak var languageStaticLabel: UILabel!
    @IBOutlet public private(set) weak var languageValueLabel: UILabel!
    @IBOutlet public private(set) weak var typeStaticLabel: UILabel!
    @IBOutlet public private(set) weak var typeValueLabel: UILabel!
    @IBOutlet public private(set) weak var thumbnailImageView: UIImageView!
    @IBOutlet public private(set) weak var imageContainer: UIView!
            
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
}
