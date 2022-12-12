// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule
import AudioPlayerModule

public class StickyAudioPlayerViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailView: DefaultImageView!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    public convenience init() {
        self.init(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    public func display(viewModel: StickyAudioPlayerViewModel) {
        titleLabel.text = viewModel.titleLabel
        descriptionLabel.text = viewModel.descriptionLabel
        playButton.setImage(viewModel.playbackViewModel.image, for: .normal)
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
        playButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 28), forImageIn: .normal)
        forwardButton.tintColor = UIColor.accentColor
        forwardButton.setImage(.init(systemName: "goforward.30"), for: .normal)
        forwardButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 24), forImageIn: .normal)
    }
}
