// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import HTTPClient
import URLSessionHTTPClient
import Combine
import CoreData
import PodcastsGenresList
import PodcastsGenresListiOS
import PodcastsModule
import PodcastsModuleiOS
import AudioPlayerModule
import AVPlayerClient

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private lazy var baseURL: URL = {
        URL(string: "https://listen-api-test.listennotes.com")!
    }()
    
    private lazy var httpClient: HTTPClient = {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var genresStore: GenresStore = {
        try! CoreDataGenresStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("genres-store.sqlite")
        )
    }()
    
    private lazy var playbackProgressStore: PlaybackProgressStore = {
        try! CoreDataPlaybackProgressStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("playback-progress-store.sqlite")
        )
    }()
    
    private lazy var localGenresLoader: LocalGenresLoader = {
        LocalGenresLoader(store: genresStore, currentDate: Date.init)
    }()
    
    private lazy var localPlaybackProgressLoader: LocalPlaybackProgressLoader = {
        LocalPlaybackProgressLoader(store: playbackProgressStore, currentDate: Date.init)
    }()
    
    var audioPlayer: AudioPlayer = {
        AVPlayerClient()
    }()
    
    var audioPlayerStatePublisher: AudioPlayerStatePublisher = {
        AudioPlayerStatePublisher()
    }()
    
    var audioPlayerStatePublishers: AudioPlayerStatePublishers = {
        AudioPlayerStatePublishers()
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        localGenresLoader.validateCache()
    }
    
    convenience init(httpClient: HTTPClient, genresStore: GenresStore) {
        self.init()
        self.httpClient = httpClient
        self.genresStore = genresStore
    }
    
    func configureWindow() {
        globalAppearanceSetup()
        composeAudioPlayerWithStatePublisher()
        window?.rootViewController = configureRootController()
        window?.makeKeyAndVisible()
    }
    
    private func configureRootController() -> UIViewController {
        let root = RootComposer.compose(
            baseURL: baseURL,
            httpClient: httpClient,
            localGenresLoader: localGenresLoader,
            audioPlayer: audioPlayer,
            audioPlayerStatePublisher: audioPlayerStatePublisher,
            audioPlayerStatePublishers: audioPlayerStatePublishers,
            playbackProgressCache: localPlaybackProgressLoader,
            localPlaybackProgressLoader: localPlaybackProgressLoader.loadPublisher
        )
        return root
    }
    
    private func globalAppearanceSetup() {
        if #available(iOS 15.0, *) {
            UITableView.appearance().isPrefetchingEnabled = false
        }
    }
    
    private func composeAudioPlayerWithStatePublisher() {
        audioPlayer.delegate = audioPlayerStatePublishers
    }
}

final class AudioPlayerStatePublishers: AudioPlayerOutputDelegate {
    typealias AudioPlayerStatePublisher = AnyPublisher<PlayerState, Never>
    typealias AudioPlayerPrepareForSeekPublisher = AnyPublisher<PlayingItem.Progress, Never>
    
    private let _audioPlayerStatePublisher = CurrentValueSubject<PlayerState, Never>(.noPlayingItem)
    private let _audioPlayerPrepareForSeekPublisher = PassthroughSubject<PlayingItem.Progress, Never>()
    
    var audioPlayerStatePublisher: AudioPlayerStatePublisher {
        _audioPlayerStatePublisher.eraseToAnyPublisher()
    }
    
    var audioPlayerPrepareForSeekPublisher: AudioPlayerPrepareForSeekPublisher {
        _audioPlayerPrepareForSeekPublisher.eraseToAnyPublisher()
    }
    
    func didUpdateState(with state: PlayerState) {
        _audioPlayerStatePublisher.send(state)
    }
    
    func prepareForProgressAfterSeekApply(futureProgress: PlayingItem.Progress) {
        _audioPlayerPrepareForSeekPublisher.send(futureProgress)
    }
}
