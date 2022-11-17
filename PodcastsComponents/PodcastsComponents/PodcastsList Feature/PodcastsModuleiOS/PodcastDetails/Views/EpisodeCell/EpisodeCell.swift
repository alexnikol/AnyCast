// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule

public final class EpisodeCell: UITableViewCell, Reusable {
    private enum Defaults {
        static let defaultBackground: UIColor = .secondarySystemBackground
        static let highlightedBackground: UIColor = .tertiarySystemBackground
    }
    @IBOutlet public private(set) weak var publishDateLabel: UILabel!
    @IBOutlet public private(set) weak var titleLabel: UILabel!
    @IBOutlet public private(set) weak var audioLengthLabel: UILabel!
    @IBOutlet public private(set) weak var desciptionView: UITextView!
    @IBOutlet private(set) weak var cellContainer: UIView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        cellContainer.layer.cornerRadius = 4.0
        desciptionView.textContainer.maximumNumberOfLines = 2
        desciptionView.textContainer.lineFragmentPadding = 0
        desciptionView.textContainerInset = .zero
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {}
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        cellContainer.backgroundColor = highlighted ? Defaults.highlightedBackground : Defaults.defaultBackground
    }
    
    public func updateDescription(_ descriptionAttributedString: NSAttributedString) {
        let attributedString = NSMutableAttributedString(attributedString: descriptionAttributedString)
        attributedString.addAttributes(
            [
                .foregroundColor: UIColor.tertiaryLabel,
                .backgroundColor: UIColor.clear,
                .font: UIFont.systemFont(ofSize: 15, weight: .medium)
            ],
            range: NSRange(location: 0, length: attributedString.string.count))
        
        desciptionView.attributedText = attributedString
    }
}
