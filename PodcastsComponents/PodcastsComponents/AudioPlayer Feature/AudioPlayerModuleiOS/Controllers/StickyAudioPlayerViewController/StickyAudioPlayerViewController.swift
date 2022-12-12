// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule

class StickyAudioPlayerViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailView: DefaultImageView!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
}

// MARK: - UI setup
private extension StickyAudioPlayerViewController {
    
    func configureViews() {
        configureActionButtons()
    }
    
    func configureActionButtons() {
        playButton.tintColor = UIColor.accentColor
        playButton.setImage(.init(systemName: "play.fill"), for: .normal)
        forwardButton.setImage(.init(systemName: "goforward.30"), for: .normal)
        forwardButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 34), forImageIn: .normal)
    }
}
