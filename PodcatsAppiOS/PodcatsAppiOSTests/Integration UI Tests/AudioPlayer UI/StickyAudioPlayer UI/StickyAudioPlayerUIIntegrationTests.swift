// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import Combine
import PodcastsModule
import AudioPlayerModule
import AudioPlayerModuleiOS
@testable import Podcats

class StickyAudioPlayerUIIntegrationTests: XCTestCase {
    
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
    
    // MARK: - Helpers
    
    private typealias SUT = (sut: StickyAudioPlayerViewController,
                             audioPlayerSpy: AudioPlayerClientDummy,
                             controlsDelegate: AudioPlayerControlsSpy)
    
    private func makeSUT(
        statePublisher: AudioPlayerStatePublisher = AudioPlayerStatePublisher(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        let controlsSpy = AudioPlayerControlsSpy()
        let audioPlayer = AudioPlayerClientDummy()
        let sut = StickyAudioPlayerUIComposer.playerWith(
            thumbnailURL: anyURL(),
            statePublisher: statePublisher,
            controlsDelegate: controlsSpy,
            imageLoader: { _ in
                Empty().eraseToAnyPublisher()
            }
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(statePublisher, file: file, line: line)
        trackForMemoryLeaks(controlsSpy, file: file, line: line)
        trackForMemoryLeaks(audioPlayer, file: file, line: line)
        audioPlayer.delegate = statePublisher
        return (sut, audioPlayer, controlsSpy)
    }
}
