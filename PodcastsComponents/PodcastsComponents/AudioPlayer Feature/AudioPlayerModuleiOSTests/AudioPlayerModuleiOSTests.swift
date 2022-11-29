// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import UIKit
import AudioPlayerModule
import AudioPlayerModuleiOS

class AudioPlayerModuleiOSTests: XCTestCase {
    
    func test_pausedPlayerPortrait() {
        let sut = makeSUT()
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_PORTRAIT_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_PORTRAIT_dark")
    }
    
    func test_pausedPlayerLandscape() {
        let sut = makeSUT()
        sut.viewWillTransition(to: .init(width: 667, height: 375), with: ViewControllerTransitionNullObject())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, orientation: .landscape)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_LANDSCAPE_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark, orientation: .landscape)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_LANDSCAPE_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> LargeAudioPlayerViewController {
        let sut = LargeAudioPlayerViewController(
            delegate: LargeAudioPlayerViewDelegateNullObject(),
            controlsDelegate: AudioPlayerControlsDelegateNullObject()
        )
        return sut
    }
    
    private class LargeAudioPlayerViewDelegateNullObject: LargeAudioPlayerViewLifetimeDelegate {
        func onOpen() {}
        func onClose() {}
    }
    
    private class AudioPlayerControlsDelegateNullObject: AudioPlayerControlsDelegate {
        func togglePlay() {}
        func changeVolumeTo(value: Float) {}
        func seekTo(progress: Float) {}
    }
    
    private class ViewControllerTransitionNullObject: NSObject, UIViewControllerTransitionCoordinator {
        func animate(alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
            return true
        }
        
        func animateAlongsideTransition(in view: UIView?, animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
            return true
        }
        
        func notifyWhenInteractionEnds(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {}
        
        func notifyWhenInteractionChanges(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {}
        
        var isAnimated: Bool = false
        
        var presentationStyle: UIModalPresentationStyle = .automatic
        
        var initiallyInteractive: Bool = false
        
        var isInterruptible: Bool = false
        
        var isInteractive: Bool = false
        
        var isCancelled: Bool = false
        
        var transitionDuration: TimeInterval = 0.0
        
        var percentComplete: CGFloat = 0.0
        
        var completionVelocity: CGFloat = 0.0
        
        var completionCurve: UIView.AnimationCurve = .easeIn
        
        func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
            return nil
        }
        
        func view(forKey key: UITransitionContextViewKey) -> UIView? {
            return nil
        }
        
        var containerView: UIView = UIView()
        
        var targetTransform: CGAffineTransform = .identity
    }
}
