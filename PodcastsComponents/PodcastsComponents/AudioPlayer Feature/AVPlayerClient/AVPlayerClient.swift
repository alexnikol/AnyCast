// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import AVKit
import PodcastsModule
import AudioPlayerModule

public final class AVPlayerClient: NSObject, AudioPlayer {
    public var isPlaying: Bool = false
    
    private enum Error: Swift.Error {
        case sendPlayerUpdatesWithoutCurrentPlayingAudioMeta
    }
    
    private enum ObservingKeyPaths: String, CaseIterable {
        case timeControlStatus
        case status
        case reasonForWaitingToPlay
        case playbackLikelyToKeepUp = "currentItem.playbackLikelyToKeepUp"
        case playbackBufferEmpty = "currentItem.playbackBufferEmpty"
        case playbackBufferFull = "currentItem.playbackBufferFull"
    }
    
    private var currentMeta: Meta?
    
    private let requiredAssetKeys: [String] = [
        "playable",
        "duration"
    ]
    
    private var periodicTimer: Any?
    public let progressPeriodicTimer = CMTime(value: 1, timescale: 10)
    
    private lazy var player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    public var delegate: AudioPlayerOutputDelegate?
    
    public override init() {
        try! AVAudioSession.sharedInstance().setCategory(.playback)
    }
    
    private var systemVolume: Float {
        var systemVolume: Float
#if os(iOS)
        systemVolume = AVAudioSession.sharedInstance().outputVolume
#elseif os(OSX)
        systemVolume = 0.0
#endif
        return systemVolume
    }
    
    public func startPlayback(fromURL url: URL, withMeta meta: Meta) {
        self.currentMeta = meta
        try? sendStartPlayingState()
        
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: requiredAssetKeys)
        player.replaceCurrentItem(with: playerItem)
        
        ObservingKeyPaths.allCases.forEach {
            player.addObserver(self, forKeyPath: $0.rawValue, options: [.new], context: nil)
        }
        
        periodicTimer = player.addPeriodicTimeObserver(
            forInterval: progressPeriodicTimer,
            queue: .global(),
            using: { [weak self] _ in
                guard let self = self,
                      let item = self.player.currentItem else {
                    return
                }
                
                switch self.player.status {
                case .readyToPlay:
                    let currentTime = Float(CMTimeGetSeconds(self.player.currentTime()))
                    let totalTime = Float(CMTimeGetSeconds(item.duration))
                    let progress = currentTime / totalTime
                    
                    print("OKP__Data \(currentTime), \(totalTime), \(progress)")
                default: ()
                }
            })
        
        player.playImmediately(atRate: 1.0)
    }
    
    public func play() {}
    
    public func pause() {}
    
    public func changeVolumeTo(value: Float) {}
    
    public func seekToProgress(_ progress: Float) {}
    
    public func seekToSeconds(_ seconds: Int) {}
    
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey: Any]?,
                                      context: UnsafeMutableRawPointer?) {
        guard (object as AnyObject? === player || object as AnyObject? === player.currentItem),
              let inputKeyPath = keyPath,
              let observingKeyPath = ObservingKeyPaths(rawValue: inputKeyPath) else {
            return
        }
        
        switch observingKeyPath {
        case .timeControlStatus:
            print("OKP__timeControlStatus: \(player.timeControlStatus)")
            
        case .reasonForWaitingToPlay:
            let bufferingCases: [AVPlayer.WaitingReason] = [.toMinimizeStalls, .evaluatingBufferingRate]
            if let reasonForWaitingToPlay = player.reasonForWaitingToPlay, bufferingCases.contains(reasonForWaitingToPlay) {

            } else {
                
            }
            
            if player.reasonForWaitingToPlay == .toMinimizeStalls || player.reasonForWaitingToPlay == .evaluatingBufferingRate {
                //                delegate?.onPlayerEvent(.startBuffering, for: self.id)
                //                playButtonState = .loading
            } else {
                //                playButtonState = audioPlayer.isPlaying ? .playing : .paused
            }
            print("OKP__reasonForWaitingToPlay: \(player.reasonForWaitingToPlay)")
            
        case .playbackLikelyToKeepUp:
            let newValue = change?[.newKey] as? Bool
            let oldValue = change?[.oldKey] as? Bool
            
            guard newValue != oldValue, let item = player.currentItem else {
                return
            }
            //            playButtonState = audioPlayer.isPlaying ? .playing : .paused
            print("OKP__playbackLikelyToKeepUp__ - \(item.isPlaybackLikelyToKeepUp)")
        case .playbackBufferEmpty:
            let newValue = change?[.newKey] as? Bool
            let oldValue = change?[.oldKey] as? Bool
            guard newValue != oldValue, let currentItem = player.currentItem else {
                return
            }
            //            playButtonState = .loading
            print("OKP__playbackBufferEmpty - START BUFFERING")
        case .playbackBufferFull:
            let newValue = change?[.newKey] as? Bool
            let oldValue = change?[.oldKey] as? Bool
            guard newValue != oldValue, let currentItem = player.currentItem else {
                return
            }
            print("OKP__playbackBufferFull - END BUFFERING")
            //            delegate?.onPlayerEvent(.endBuffering, for: self.id)
            //            playButtonState = audioPlayer.isPlaying ? .playing : .paused
        case .status:
            guard let currentItem = player.currentItem else {
                return
            }
            
            print("OKP__STATUS___\(currentItem.status)")
            if currentItem.status == .readyToPlay {
                let assets = currentItem.asset
                //                playButtonState = audioPlayer.isPlaying ? .playing : .paused
                print("OKP__isREADYTO_plau__ - \(assets)")
            }
        }
    }
    
    private func sendStartPlayingState() throws {
        guard let meta = currentMeta else {
            throw Error.sendPlayerUpdatesWithoutCurrentPlayingAudioMeta
        }
//
//        let item = PlayingItem(
//            episode: meta.episode,
//            podcast: meta.podcast,
//            state: .init(
//                playbackState: .playing,
//                currentTimeInSeconds: 0,
//                totalTime: .notDefined,
//                progressTimePercentage: 0.0,
//                volumeLevel: systemVolume
//            )
//        )
//        delegate?.didUpdateState(with: .startPlayingNewItem(item))
    }
    
    private func sendUpdatePlayingState(state: PlayingItem.State) throws {
        guard let meta = currentMeta else {
            throw Error.sendPlayerUpdatesWithoutCurrentPlayingAudioMeta
        }
//        
//        let item = PlayingItem(
//            episode: meta.episode,
//            podcast: meta.podcast,
//            state: state
//        )
//        delegate?.didUpdateState(with: .updatedPlayingItem(item))
    }
}
