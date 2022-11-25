// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule

public final class LargeAudioPlayerViewController: UIViewController {
    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var progressView: UISlider!
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var rightTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var volumeView: UISlider!
    @IBOutlet weak var leftVolumeIconView: UIImageView!
    @IBOutlet weak var rightVolumeIconView: UIImageView!
    @IBOutlet public private(set) weak var imageMainContainer: UIView!
    @IBOutlet public private(set) weak var imageInnerContainer: UIView!
    @IBOutlet weak var thumbnailIWidthCNST: NSLayoutConstraint!
    @IBOutlet weak var thumbnailIHeightCNST: NSLayoutConstraint!
    @IBOutlet weak var bottomSpacer: UIView!
    @IBOutlet weak var controlsStackView: UIStackView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
        
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateStacksDueToOrientation()
    }
    
    private func updateStacksDueToOrientation() {
        if UIDevice.current.orientation.isLandscape {
            bottomSpacer?.isHidden = true
            rootStackView?.axis = .horizontal
            controlsStackView?.axis = .horizontal
            controlsStackView?.distribution = .fill
            controlsStackView?.alignment = .center
            titleLabel?.textAlignment = .left
            descriptionLabel?.textAlignment = .left
        } else {
            bottomSpacer?.isHidden = false
            rootStackView?.axis = .vertical
            controlsStackView?.axis = .vertical
            controlsStackView?.distribution = .equalCentering
            controlsStackView?.alignment = .fill
            titleLabel?.textAlignment = .center
            descriptionLabel?.textAlignment = .center
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMainLayoutDueToOrientation()
    }
    
    private func updateMainLayoutDueToOrientation() {
        if UIDevice.current.orientation.isLandscape {
            thumbnailIHeightCNST?.isActive = false
            thumbnailIWidthCNST?.isActive = true
        } else {
            thumbnailIWidthCNST?.isActive = false
            thumbnailIHeightCNST?.isActive = true
        }
    }
    
    private func configureViews() {
        configureThumbnailView()
        configureVolumeViews()
        configureActionButtons()
    }
    
    private func configureThumbnailView() {
        imageInnerContainer.layer.cornerRadius = 4.0
        imageMainContainer.layer.cornerRadius = 4.0
        imageMainContainer.layer.shadowColor = UIColor.tintColor.cgColor
        imageMainContainer.layer.shadowOpacity = 0.5
        imageMainContainer.layer.shadowOffset = .zero
        imageMainContainer.layer.shadowRadius = 10.0
    }
    
    private func configureVolumeViews() {
        leftVolumeIconView.image = .init(systemName: "speaker.fill")
        rightVolumeIconView.image = .init(systemName: "speaker.wave.1.fill")
    }
    
    private func configureActionButtons() {
        playButton.layer.cornerRadius = 4.0
        playButton.tintColor = UIColor.tintColor
        playButton.setImage(.init(systemName: "play.fill"), for: .normal)
        forwardButton.setImage(.init(systemName: "goforward.30"), for: .normal)
        backwardButton.setImage(.init(systemName: "gobackward.15"), for: .normal)
        forwardButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 34), forImageIn: .normal)
        backwardButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 34), forImageIn: .normal)
    }
}
