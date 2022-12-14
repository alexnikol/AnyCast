// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import SharedComponentsiOSModule
import LoadResourcePresenter

public class ThumbnailDynamicPresentationAdapter<Resource, View: ResourceView>: ThumbnailSourceDelegate {
    private var url: URL?
    private var cancellable: AnyCancellable?
    var presenter: LoadResourcePresenter<Resource, View>?
    private let loader: (URL) -> AnyPublisher<Resource, Error>
    
    init(loader: @escaping (URL) -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    public func didUpdateSourceURL(_ url: URL) {
        guard self.url != url else { return }
        self.url = url
        self.didRequestCancel()
        self.didRequestLoading()
    }
    
    private func didRequestLoading() {
        presenter?.didStartLoading()
        cancellable = loader(url!)
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] result in
                    switch result {
                    case .finished: break
                        
                    case let .failure(error):
                        self?.presenter?.didFinishLoading(with: error)
                    }
                },
                receiveValue: { [weak self] data in
                    self?.presenter?.didFinishLoading(with: data)
                }
            )
    }
    
    private func didRequestCancel() {
        cancellable?.cancel()
    }
}
