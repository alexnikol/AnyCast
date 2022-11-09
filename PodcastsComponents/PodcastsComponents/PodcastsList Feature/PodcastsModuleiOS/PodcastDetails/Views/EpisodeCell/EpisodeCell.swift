// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public final class EpisodeCell: UITableViewCell, NibReusable {
    @IBOutlet public private(set) weak var titleLabel: UILabel!
    @IBOutlet public private(set) weak var descriptionLabel: UILabel!
    @IBOutlet public private(set) weak var audioLengthLabel: UILabel!
        
    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {}
}
