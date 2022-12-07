// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import AVKit
import PodcastsModule
import AudioPlayerModule

public final class AVPlayerClient: NSObject, AudioPlayer {
    
    private enum Error: Swift.Error {
        case sendPlayerUpdatesWithoutCurrentPlayingAudioMeta
    }
    
    private enum ObservingKeyPaths: String, CaseIterable {
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
    public let progressPeriodicTimer = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    
    private lazy var player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = true
        return player
    }()
    
    public var delegate: AudioPlayerOutputDelegate?
    
    public override init() {
        try! AVAudioSession.sharedInstance().setCategory(.playback)
        super.init()
        subscribeOnVolumeChange()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public var isPlaying: Bool {
        return player.rate != 0 && player.error == nil
    }
    
    private var lastPlaybackState: PlayingItem.PlaybackState?
    private var lastProgressState: PlayingItem.Progress?
    private var lastVolumeState: Float?
    private var lastSpeedPlaybackState: PlaybackSpeed?
    
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
                    var progress: PlayingItem.Progress
                    guard !currentTime.isNaN, currentTime >= 0 else {
                        progress = PlayingItem.Progress(
                            currentTimeInSeconds: 0,
                            totalTime: .notDefined,
                            progressTimePercentage: 0.0
                        )
                        self.updateProgress(progress: progress)
                        return
                    }
                    
                    let currentTimeInSeconds = Int(currentTime)
                    if totalTime.isNaN {
                        progress = PlayingItem.Progress(
                            currentTimeInSeconds: currentTimeInSeconds,
                            totalTime: .notDefined,
                            progressTimePercentage: 0.0
                        )
                    } else {
                        let progressPercentage = currentTime / totalTime
                        let totalTimeInSeconds = Int(totalTime)
                        progress = PlayingItem.Progress(
                            currentTimeInSeconds: currentTimeInSeconds,
                            totalTime: .valueInSeconds(totalTimeInSeconds),
                            progressTimePercentage: progressPercentage
                        )
                    }
                    
                    self.updateProgress(progress: progress)
                default: ()
                }
            })
        
        player.playImmediately(atRate: 1.0)
    }
    
    public func play() {
        player.play()
    }
    
    public func pause() {
        player.pause()
    }
    
    public func changeVolumeTo(value: Float) {
        updateVolume(volume: value)
    }
    
    public func seekToProgress(_ progress: Float) {
        guard let duration  = player.currentItem?.duration else {
            return
        }
        let newTime = Float64(Float(CMTimeGetSeconds(duration)) * progress)
        
        if newTime > 0 && newTime < (CMTimeGetSeconds(duration)) {
            let newTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            player.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    
    public func seekToSeconds(_ seconds: Int) {
        let seekValue = TimeInterval(seconds)
        guard let duration  = player.currentItem?.duration else {
            return
        }
        let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = playerCurrentTime + seekValue
        
        if newTime > 0 && newTime < (CMTimeGetSeconds(duration) - seekValue) {
            let newTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            player.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    
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
        case .reasonForWaitingToPlay:
            let bufferingCases: [AVPlayer.WaitingReason] = [.toMinimizeStalls, .evaluatingBufferingRate, .noItemToPlay]
            if let reasonForWaitingToPlay = player.reasonForWaitingToPlay, bufferingCases.contains(reasonForWaitingToPlay) {
                updatePlayback(playback: .loading)
            } else {
                updatePlayback(playback: isPlaying ? .playing : .pause)
            }
            print("OKP__reasonForWaitingToPlay: \(player.reasonForWaitingToPlay?.rawValue ?? "NO reason")")
            
        case .playbackLikelyToKeepUp:
            let newValue = change?[.newKey] as? Bool
            let oldValue = change?[.oldKey] as? Bool
            guard newValue != oldValue else {
                return
            }
            updatePlayback(playback: isPlaying ? .playing : .pause)
            
        case .playbackBufferEmpty:
            let newValue = change?[.newKey] as? Bool
            let oldValue = change?[.oldKey] as? Bool
            guard newValue != oldValue else {
                return
            }
            updatePlayback(playback: .loading)
            
        case .playbackBufferFull:
            let newValue = change?[.newKey] as? Bool
            let oldValue = change?[.oldKey] as? Bool
            guard newValue != oldValue else {
                return
            }
            updatePlayback(playback: isPlaying ? .playing : .pause)
            
        case .status:
            guard let currentItem = player.currentItem else {
                return
            }
            
            print("OKP__STATUS___\(currentItem.status)")
            if currentItem.status == .readyToPlay {
                let assets = currentItem.asset
                updatePlayback(playback: isPlaying ? .playing : .pause)
                print("OKP__isREADYTO_plau__ - \(assets)")
            }
        }
    }
    
    private func sendStartPlayingState() throws {
        guard let meta = currentMeta else {
            throw Error.sendPlayerUpdatesWithoutCurrentPlayingAudioMeta
        }
        
        let playback = PlayingItem.PlaybackState.playing
        let volume = systemVolume
        let progress = PlayingItem.Progress(
            currentTimeInSeconds: 0,
            totalTime: .notDefined,
            progressTimePercentage: 0
        )
        let speedPlayback = PlaybackSpeed.x1
        
        lastPlaybackState = playback
        lastProgressState = progress
        lastVolumeState = volume
        lastSpeedPlaybackState = speedPlayback
        
        let playingItem = PlayingItem(
            episode: meta.episode,
            podcast: meta.podcast,
            updates: [
                .playback(playback),
                .progress(progress),
                .volumeLevel(volume),
                .speed(speedPlayback)
            ]
        )
        delegate?.didUpdateState(with: .startPlayingNewItem(playingItem))
    }
    
    private func updateProgress(progress: PlayingItem.Progress) {
        lastProgressState = progress
        try? sendUpdatePlayingState(states: currentStatesList())
    }
    
    private func updatePlayback(playback: PlayingItem.PlaybackState) {
        lastPlaybackState = playback
        try? sendUpdatePlayingState(states: currentStatesList())
    }
    
    private func updateVolume(volume: Float) {
        lastVolumeState = volume
        try? sendUpdatePlayingState(states: currentStatesList())
    }
    
    func subscribeOnVolumeChange() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(systemVolumeDidChange),
                                               name: Notification.Name("SystemVolumeDidChange"),
                                               object: nil)
    }
    
    @objc
    private func systemVolumeDidChange(notification: NSNotification) {
        guard let volumeValue = notification.userInfo?["Volume"] as? Float, (0...1).contains(volumeValue) else { return }
        updateVolume(volume: volumeValue)
    }
    
    private func sendUpdatePlayingState(states: [PlayingItem.State]) throws {
        guard let meta = currentMeta else {
            throw Error.sendPlayerUpdatesWithoutCurrentPlayingAudioMeta
        }
        
        let playingItem = PlayingItem(
            episode: meta.episode,
            podcast: meta.podcast,
            updates: states
        )
        delegate?.didUpdateState(with: .updatedPlayingItem(playingItem))
    }
    
    private func currentStatesList() -> [PlayingItem.State] {
        var updates: [PlayingItem.State] = []
        
        if let playbackState = lastPlaybackState {
            updates.append(.playback(playbackState))
        }
        
        if let volumeState = lastVolumeState {
            updates.append(.volumeLevel(volumeState))
        }
        
        if let progressState = lastProgressState {
            updates.append(.progress(progressState))
        }
        
        if let speedPlaybackState = lastSpeedPlaybackState {
            updates.append(.speed(speedPlaybackState))
        }
        return updates
    }
}
