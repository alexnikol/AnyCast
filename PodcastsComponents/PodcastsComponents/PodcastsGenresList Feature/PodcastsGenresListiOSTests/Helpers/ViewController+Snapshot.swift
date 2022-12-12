// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsModuleiOS

extension UIViewController {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        return SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
    
    func updateFrameWith(orientation: SnapshotConfiguration.Orientation) {
        self.view.frame = CGRect(origin: .zero, size: orientation.size)
    }
    
    func updateFrameWith(frame: CGRect) {
        self.view.frame = frame
    }
}

struct SnapshotConfiguration {
    enum Orientation {
        case landscape
        case portrait
        
        var size: CGSize {
            switch self {
            case .landscape:
                return CGSize(width: 844, height: 390)
            case .portrait:
                return CGSize(width: 390, height: 844)
            }
        }
        
        var safeAreaInsets: UIEdgeInsets {
            switch self {
            case .landscape:
                return UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47)
            case .portrait:
                return UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0)
            }
        }
        
        var layoutMargins: UIEdgeInsets {
            switch self {
            case .landscape:
                return UIEdgeInsets(top: 8, left: 55, bottom: 29, right: 55)
            case .portrait:
                return UIEdgeInsets(top: 55, left: 8, bottom: 42, right: 8)
            }
        }
    }
    
    let size: CGSize
    let safeAreaInsets: UIEdgeInsets
    let layoutMargins: UIEdgeInsets
    let traitCollection: UITraitCollection
    
    static func iPhone14(
        style: UIUserInterfaceStyle,
        contentSize: UIContentSizeCategory = .medium,
        orientation: SnapshotConfiguration.Orientation = .portrait
    ) -> SnapshotConfiguration {
        return SnapshotConfiguration(
            size: orientation.size,
            safeAreaInsets: orientation.safeAreaInsets,
            layoutMargins: orientation.layoutMargins,
            traitCollection: UITraitCollection(traitsFrom: [
                .init(forceTouchCapability: .unavailable),
                .init(layoutDirection: .leftToRight),
                .init(preferredContentSizeCategory: contentSize),
                .init(userInterfaceIdiom: .phone),
                .init(horizontalSizeClass: .compact),
                .init(verticalSizeClass: .regular),
                .init(displayScale: 3),
                .init(accessibilityContrast: .normal),
                .init(displayGamut: .P3),
                .init(userInterfaceStyle: style)
            ])
        )
    }
}

private final class SnapshotWindow: UIWindow {
    private var configuration: SnapshotConfiguration = .iPhone14(style: .light)
    
    convenience init(configuration: SnapshotConfiguration, root: UIViewController) {
        self.init(frame: CGRect(origin: .zero, size: configuration.size))
        self.configuration = configuration
        self.layoutMargins = configuration.layoutMargins
        self.rootViewController = root
        self.isHidden = false
        root.view.layoutMargins = configuration.layoutMargins
    }
    
    override var safeAreaInsets: UIEdgeInsets {
        return configuration.safeAreaInsets
    }
    
    override var traitCollection: UITraitCollection {
        return UITraitCollection(traitsFrom: [super.traitCollection, configuration.traitCollection])
    }
    
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
        return renderer.image { action in
            layer.render(in: action.cgContext)
        }
    }
}
