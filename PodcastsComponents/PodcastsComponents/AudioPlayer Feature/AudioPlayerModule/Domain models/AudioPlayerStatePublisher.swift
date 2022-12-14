// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol AudioPlayerStateSubscription {
    func unsubscribe()
}

public class AudioPlayerStatePublisher {
    private var previosState: PlayerState?
    private var observers: [UUID: AudioPlayerObserver] = [:]
        
    public init() {}
    
    public func subscribe(observer: AudioPlayerObserver) -> AudioPlayerStateSubscription {
        let subscriptionID = UUID()
        self.observers[subscriptionID] = observer
        updateStateOfAttachedObserverIfPreviousStateExists(observer)
        let subscription = StateSubscription(onUnsubscribe: { [weak self] in
            self?.observers.removeValue(forKey: subscriptionID)
        })
        return subscription
    }
        
    private func updateObserversWithStateUpdate(with state: PlayerState) {
        observers.forEach { (key, observer) in
            observer.receive(state)
        }
    }
    
    private func updateObserversWithFutureSeekProgress(with progress: PlayingItem.Progress) {
        observers.forEach { (key, observer) in
            observer.prepareForSeek(progress)
        }
    }
    
    private func updateStateOfAttachedObserverIfPreviousStateExists(_ observer: AudioPlayerObserver) {
        guard let previosState = previosState else {
            return
        }
        updateObserversWithStateUpdate(with: previosState)
    }
}

extension AudioPlayerStatePublisher: AudioPlayerOutputDelegate {
    
    public func didUpdateState(with state: PlayerState) {
        previosState = state
        updateObserversWithStateUpdate(with: state)
    }
    
    public func prepareForProgressAfterSeekApply(futureProgress: PlayingItem.Progress) {
        updateObserversWithFutureSeekProgress(with: futureProgress)
    }
}

extension AudioPlayerStatePublisher {
    private struct StateSubscription: AudioPlayerStateSubscription {
        let onUnsubscribe: () -> Void
        
        init(onUnsubscribe: @escaping () -> Void) {
            self.onUnsubscribe = onUnsubscribe
        }
        
        func unsubscribe() {
            onUnsubscribe()
        }
    }
}
