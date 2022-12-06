// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule
import AudioPlayerModule
import MediaPlayer

public final class LargeAudioPlayerViewController: UIViewController {
    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet public private(set) weak var progressView: UISlider!
    @IBOutlet public private(set) weak var leftTimeLabel: UILabel!
    @IBOutlet public private(set) weak var rightTimeLabel: UILabel!
    @IBOutlet public private(set) weak var titleLabel: UILabel!
    @IBOutlet public private(set) weak var descriptionLabel: UILabel!
    @IBOutlet public private(set) weak var playButton: UIButton!
    @IBOutlet public private(set) weak var forwardButton: UIButton!
    @IBOutlet public private(set) weak var backwardButton: UIButton!
    @IBOutlet public private(set) weak var volumeView: UISlider!
    @IBOutlet weak var leftVolumeIconView: UIImageView!
    @IBOutlet weak var rightVolumeIconView: UIImageView!
    @IBOutlet public private(set) weak var imageMainContainer: UIView!
    @IBOutlet public private(set) weak var imageInnerContainer: UIView!
    @IBOutlet weak var thumbnailIWidthCNST: NSLayoutConstraint!
    @IBOutlet weak var thumbnailIHeightCNST: NSLayoutConstraint!
    @IBOutlet weak var rootStackViewTopCNST: NSLayoutConstraint!
    @IBOutlet weak var controlsStackView: UIStackView!
    private var delegate: LargeAudioPlayerViewLifetimeDelegate?
    private var controlsDelegate: AudioPlayerControlsDelegate?
    private var hiddenMPVolumeSliderControl: UISlider?
    
    // MARK: - Initialization
    
    public convenience init(delegate: LargeAudioPlayerViewLifetimeDelegate, controlsDelegate: AudioPlayerControlsDelegate) {
        self.init(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
        self.delegate = delegate
        self.controlsDelegate = controlsDelegate
    }
    
    deinit {
        delegate?.onClose()
    }
    
    // MARK: - Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        updateInitialValuesOnCreate()
        configureViews()
        delegate?.onOpen()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateToInterfaceOrientation()
    }
    
    // MARK: - Actions
        
    @IBAction public func playToggleTap(_ sender: Any) {
        guard let controlsDelegate = controlsDelegate else { return }
        controlsDelegate.isPlaying ? controlsDelegate.pause() : controlsDelegate.play()
    }
    
    @IBAction public func goForewardTap(_ sender: Any) {
        controlsDelegate?.seekToSeconds(30)
    }
    
    @IBAction public func goBackwardTap(_ sender: Any) {
        controlsDelegate?.seekToSeconds(-15)
    }
    
    @IBAction public func seekDidChange(_ sender: UISlider) {
        controlsDelegate?.seekToProgress(sender.value)
    }
    
    @IBAction public func volumeDidChange(_ sender: UISlider) {
        controlsDelegate?.changeVolumeTo(value: sender.value)
    }
    
    // MARK: - Public methods
    
    public func display(viewModel: LargeAudioPlayerViewModel) {
        titleLabel.text = viewModel.titleLabel
        descriptionLabel.text = viewModel.descriptionLabel
        updateUIWithUpdatesList(viewModel.updates)
    }
    
    private func updateUIWithUpdatesList(_ list: [LargeAudioPlayerViewModel.UpdatesViewModel]) {
        list.forEach { updateViewModel in
            switch updateViewModel {
            case let .playback(state):
                playButton.setImage(state.image, for: .normal)
                
            case let .volumeLevel(volumeLevel):
                volumeView.value = volumeLevel
                hiddenMPVolumeSliderControl?.value = volumeLevel
                
            case let .progress(progressViewModel):
                progressView.value = progressViewModel.progressTimePercentage
                leftTimeLabel.text = progressViewModel.currentTimeLabel
                rightTimeLabel.text = progressViewModel.endTimeLabel
            }
        }
    }
}

// MARK: - UI setup
private extension LargeAudioPlayerViewController {
    
    func updateInitialValuesOnCreate() {
        titleLabel.text = nil
        descriptionLabel.text = nil
        progressView.value = 0
        volumeView.value = 0
        leftTimeLabel.text = nil
        rightTimeLabel.text = nil
    }
    
    func configureViews() {
        configureThumbnailView()
        configureVolumeViews()
        configureActionButtons()
        configureMPVolumeView()
    }
    
    func configureThumbnailView() {
        imageInnerContainer.layer.cornerRadius = 4.0
        imageMainContainer.layer.cornerRadius = 4.0
        imageMainContainer.layer.shadowColor = UIColor.tintColor.cgColor
        imageMainContainer.layer.shadowOpacity = 0.5
        imageMainContainer.layer.shadowOffset = .zero
        imageMainContainer.layer.shadowRadius = 10.0
    }
    
    func configureVolumeViews() {
        leftVolumeIconView.image = .init(systemName: "speaker.fill")
        rightVolumeIconView.image = .init(systemName: "speaker.wave.1.fill")
    }
    
    func configureActionButtons() {
        playButton.layer.cornerRadius = 4.0
        playButton.tintColor = UIColor.tintColor
        playButton.setImage(.init(systemName: "play.fill"), for: .normal)
        forwardButton.setImage(.init(systemName: "goforward.30"), for: .normal)
        backwardButton.setImage(.init(systemName: "gobackward.15"), for: .normal)
        forwardButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 34), forImageIn: .normal)
        backwardButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 34), forImageIn: .normal)
    }
    
    func configureMPVolumeView() {
        let volumeControl = MPVolumeView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        self.view.addSubview(volumeControl)
        volumeControl.isHidden = true
        let lst = volumeControl.subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}
        let slider = lst.first as? UISlider
        hiddenMPVolumeSliderControl = slider
    }
}

// MARK: - Rotation logic
private extension LargeAudioPlayerViewController {
    
    func updateToInterfaceOrientation() {
        let isPortrait = view.frame.height > view.frame.width
        thumbnailIHeightCNST?.isActive = isPortrait ? true : false
        thumbnailIWidthCNST?.isActive = isPortrait ? false : true
        rootStackViewTopCNST?.constant = isPortrait ? 0.0 : 24.0
        view.layoutIfNeeded()
        
        rootStackView?.axis = isPortrait ? .vertical : .horizontal
        controlsStackView?.axis = isPortrait ? .vertical : .horizontal
        controlsStackView?.alignment = isPortrait ? .fill : .center
        titleLabel?.textAlignment = isPortrait ? .center : .left
        descriptionLabel?.textAlignment = isPortrait ? .center : .left
    }
}

// MARK: - PlaybackStateViewModel helpers
private extension PlaybackStateViewModel {
    
    var image: UIImage {
        switch self {
        case .playing:
            return UIImage(systemName: "pause.fill")!
        case .pause:
            return UIImage(systemName: "play.fill")!
        case .loading:
            return UIImage(systemName: "circle.hexagonpath.fill")!
        }
    }
}
