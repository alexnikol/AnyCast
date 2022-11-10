// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public final class EpisodeCell: UITableViewCell, NibReusable {
    private enum Defaults {
        static let defaultBackground: UIColor = .secondarySystemBackground
        static let highlightedBackground: UIColor = .tertiarySystemBackground
    }
    @IBOutlet public private(set) weak var publishDateLabel: UILabel!
    @IBOutlet public private(set) weak var titleLabel: UILabel!
    @IBOutlet public private(set) weak var descriptionLabel: UILabel!
    @IBOutlet public private(set) weak var audioLengthLabel: UILabel!
    @IBOutlet private(set) weak var cellContainer: UIView!
        
    override public func awakeFromNib() {
        super.awakeFromNib()
        cellContainer.layer.cornerRadius = 4.0
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {}
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        cellContainer.backgroundColor = highlighted ? Defaults.highlightedBackground : Defaults.defaultBackground
    }
}
