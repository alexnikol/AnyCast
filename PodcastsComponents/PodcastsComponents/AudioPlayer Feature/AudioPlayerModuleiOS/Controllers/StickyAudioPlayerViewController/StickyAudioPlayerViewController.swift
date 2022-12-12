// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule
import AudioPlayerModule

public class StickyAudioPlayerViewController: UIViewController {
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    @IBOutlet private(set) weak var thumbnailView: DefaultImageView!
    @IBOutlet private(set) weak var forwardButton: UIButton!
    @IBOutlet private(set) weak var playButton: UIButton!
    private var delegate: StickyAudioPlayerViewDelegate?
    private var controlsDelegate: AudioPlayerControlsDelegate?
    private var thumbnailViewController: ThumbnailViewController?
    
    public convenience init(
        delegate: StickyAudioPlayerViewDelegate,
        controlsDelegate: AudioPlayerControlsDelegate,
        thumbnailViewController: ThumbnailViewController
    ) {
        self.init(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
        self.delegate = delegate
        self.controlsDelegate = controlsDelegate
        self.thumbnailViewController = thumbnailViewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    @IBAction public func playToggleTap(_ sender: Any) {
        guard let controlsDelegate = controlsDelegate else { return }
        controlsDelegate.isPlaying ? controlsDelegate.pause() : controlsDelegate.play()
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
