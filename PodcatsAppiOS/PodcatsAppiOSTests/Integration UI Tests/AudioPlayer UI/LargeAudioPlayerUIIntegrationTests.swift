// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule
import AudioPlayerModule
import AudioPlayerModuleiOS
@testable import Podcats

class LargeAudioPlayerUIIntegrationTests: XCTestCase {
    
    func test_onLoad_doesNotSendsControlSignals() {
        let (sut, _, controlsSpy) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(controlsSpy.messages.isEmpty)
    }
    
    func test_sendControlMessages_sendTogglePlaybackStateToControlsDelegate() {
        let (sut, _, controlsSpy) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateUserInitiatedTogglePlaybackEpisode()
        
        XCTAssertEqual(controlsSpy.messages, [.tooglePlaybackState])
    }
    
    func test_sendControlMessages_sendVolumeStateToControlsDelegate() {
        let (sut, _, controlsSpy) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateUserInitiatedVolumeChange(to: 0.5)
        sut.simulateUserInitiatedVolumeChange(to: 0.1)
        
        XCTAssertEqual(controlsSpy.messages, [.volumeChange(0.5), .volumeChange(0.1)])
    }
    
    func test_sendControlMessages_sendSeekStateToControlsDelegate() {
        let (sut, _, controlsSpy) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateUserInitiatedSeekToProgess(to: 0.0)
        sut.simulateUserInitiatedSeekToProgess(to: 0.6)
        sut.simulateUserInitiatedSeekBackward()
        sut.simulateUserInitiatedSeekForeward()
        
        XCTAssertEqual(
            controlsSpy.messages,
            [.seekToProgress(0.0), .seekToProgress(0.6), .seekToSeconds(-15), .seekToSeconds(30)]
        )
    }
    
    func test_rendersState_rendersCurrentPlayersStateAndUpdateStateOnNewReceive() {
        let (sut, audioPlayerSpy, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: nil)
        
        let playingItem1 = PlayingItem(
            episode: makeEpisode(),
            podcast: makePodcast(),
            state: PlayingItem.State(
                playbackState: .playing,
                currentTimeInSeconds: 10,
                totalTime: .notDefined,
                progressTimePercentage: 0.1,
                volumeLevel: 0.5
            )
        )
        audioPlayerSpy.sendNewPlayerState(.startPlayingNewItem(playingItem1))
        assertThat(sut, isRendering: playingItem1)
        
        let playingItem2 = PlayingItem(
            episode: makeEpisode(),
            podcast: makePodcast(title: "Another Podcast Title", publisher: "Another Publisher"),
            state: PlayingItem.State(
                playbackState: .playing,
                currentTimeInSeconds: 10,
                totalTime: .notDefined,
                progressTimePercentage: 0.1,
                volumeLevel: 0.5
            )
        )
        audioPlayerSpy.sendNewPlayerState(.startPlayingNewItem(playingItem2))
        assertThat(sut, isRendering: playingItem2)
    }
    
    func test_rendersState_receiveCurrentPlayingStateWhenPlayerCreatedWhenCurrentPlayerItemAlreadyPlaying() {
        let sharedPublisher = AudioPlayerStatePublisher()
        var sut1: SUT? = makeSUT(statePublisher: sharedPublisher)
        sut1?.sut.loadViewIfNeeded()
        
        let playingItem = PlayingItem(
            episode: makeEpisode(),
            podcast: makePodcast(),
            state: PlayingItem.State(
                playbackState: .playing,
                currentTimeInSeconds: 10,
                totalTime: .notDefined,
                progressTimePercentage: 0.1,
                volumeLevel: 0.5
            )
        )
        sut1?.audioPlayerSpy.sendNewPlayerState(.startPlayingNewItem(playingItem))
        
        sut1 = nil
        
        let (sut2, _, _) = makeSUT(statePublisher: sharedPublisher)
        sut2.loadViewIfNeeded()
        
        assertThat(sut2, isRendering: playingItem)
    }
        
    // MARK: - Helpers
    
    private typealias SUT = (sut: LargeAudioPlayerViewController,
                             audioPlayerSpy: AudioPlayerClientSpy,
                             controlsDelegate: AudioPlayerControlsSpy)
    
    private func makeSUT(
        statePublisher: AudioPlayerStatePublisher = AudioPlayerStatePublisher(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        let controlsSpy = AudioPlayerControlsSpy()
        let audioPlayer = AudioPlayerClientSpy()
        let sut = AudioPlayerUIComposer.largePlayerWith(
            statePublisher: statePublisher,
            controlsDelegate: controlsSpy
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(statePublisher, file: file, line: line)
        trackForMemoryLeaks(controlsSpy, file: file, line: line)
        trackForMemoryLeaks(audioPlayer, file: file, line: line)
        audioPlayer.delegate = statePublisher
        return (sut, audioPlayer, controlsSpy)
    }
    
    private func assertThat(
        _ sut: LargeAudioPlayerViewController,
        isRendering playingItem: PlayingItem?,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard let playingItem = playingItem else {
            XCTAssertEqual(sut.episodeTitleText(), nil, file: file, line: line)
            XCTAssertEqual(sut.episodeDescriptionText(), nil, file: file, line: line)
            XCTAssertEqual(sut.leftTimeLabelText(), nil, file: file, line: line)
            XCTAssertEqual(sut.rightTimeLabelText(), nil, file: file, line: line)
            XCTAssertEqual(sut.volumeLevel(), 0, file: file, line: line)
            XCTAssertEqual(sut.playbackProgress(), 0, file: file, line: line)
            return
        }
        
        let viewModel = makePresenter().map(playingItem: playingItem)
        XCTAssertEqual(sut.episodeTitleText(), viewModel.titleLabel, file: file, line: line)
        XCTAssertEqual(sut.episodeDescriptionText(), viewModel.descriptionLabel, file: file, line: line)
        XCTAssertEqual(sut.leftTimeLabelText(), viewModel.currentTimeLabel, file: file, line: line)
        XCTAssertEqual(sut.rightTimeLabelText(), viewModel.endTimeLabel, file: file, line: line)
        XCTAssertEqual(sut.volumeLevel(), viewModel.volumeLevel, file: file, line: line)
        XCTAssertEqual(sut.playbackProgress(), viewModel.progressTimePercentage, file: file, line: line)
    }
    
    private func makePresenter(file: StaticString = #file, line: UInt = #line) -> LargeAudioPlayerPresenter {
        class AudioPlayerViewNullObject: AudioPlayerView {
            func display(viewModel: LargeAudioPlayerViewModel) {}
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        let presenter = LargeAudioPlayerPresenter(
            resourceView: AudioPlayerViewNullObject(),
            calendar: calendar,
            locale: locale
        )
        trackForMemoryLeaks(presenter, file: file, line: line)
        return presenter
    }
    
    private class AudioPlayerControlsSpy: AudioPlayerControlsDelegate {
        enum Message: Equatable {
            case tooglePlaybackState
            case volumeChange(Float)
            case seekToProgress(Float)
            case seekToSeconds(Int)
        }
        
        private(set) var messages: [Message] = []
        
        func togglePlay() {
            messages.append(.tooglePlaybackState)
        }
        
        func changeVolumeTo(value: Float) {
            messages.append(.volumeChange(value))
        }
        
        func seekToProgress(_ progress: Float) {
            messages.append(.seekToProgress(progress))
        }
        
        func seekToSeconds(_ seconds: Int) {
            messages.append(.seekToSeconds(seconds))
        }
    }
    
    private class AudioPlayerClientSpy: AudioPlayer {
        var delegate: AudioPlayerOutputDelegate?
        
        func sendNewPlayerState(_ state: PlayerState) {
            delegate?.didUpdateState(with: state)
        }
    }
    
    private func makeEpisode() -> Episode {
        Episode(
            id: UUID().uuidString,
            title: "Any Episode Title",
            description: "Any Episode Description",
            thumbnail: anyURL(),
            audio: anyURL(),
            audioLengthInSeconds: Int.random(in: 1...1000),
            containsExplicitContent: Bool.random(),
            publishDateInMiliseconds: Int.random(in: 1479110301853...1479110401853)
        )
    }
    
    func makePodcast(title: String = "Any Podcast Title", publisher: String = "Any Publisher Title") -> PodcastDetails {
        PodcastDetails(
            id: UUID().uuidString,
            title: title,
            publisher: publisher,
            language: "Any language",
            type: .episodic,
            image: anyURL(),
            episodes: [],
            description: "Any description",
            totalEpisodes: 100
        )
    }
}
