// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule

public final class PodcastCell: UITableViewCell, Reusable {
    private enum Defaults {
        static let defaultBackground: UIColor = .secondarySystemBackground
        static let highlightedBackground: UIColor = .tertiarySystemBackground
    }
    @IBOutlet public private(set) weak var titleLabel: UILabel!
    @IBOutlet public private(set) weak var publisherLabel: UILabel!
    @IBOutlet public private(set) weak var languageStaticLabel: UILabel!
    @IBOutlet public private(set) weak var languageValueLabel: UILabel!
    @IBOutlet public private(set) weak var typeStaticLabel: UILabel!
    @IBOutlet public private(set) weak var typeValueLabel: UILabel!
    @IBOutlet public private(set) weak var thumbnailImageView: DefaultImageView!
    @IBOutlet private(set) weak var cellContainer: UIView!
            
    public override func awakeFromNib() {
        super.awakeFromNib()
        cellContainer.layer.cornerRadius = 4.0
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.imageView.image = nil
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {}
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        cellContainer.backgroundColor = highlighted ? Defaults.highlightedBackground : Defaults.defaultBackground
    }
}
