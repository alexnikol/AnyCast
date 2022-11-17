// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import LoadResourcePresenter
import SharedComponentsiOSModule

final class GenericLoaderPresentationAdapter<Resource, View: ResourceView>: RefreshViewControllerDelegate {
    private let loader: () -> AnyPublisher<Resource, Error>
    private var cancellable: AnyCancellable?
    var presenter: LoadResourcePresenter<Resource, View>?
    
    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    func didRequestLoading() {
        presenter?.didStartLoading()
        cancellable = loader()
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
    
    func didRequestCancel() {
        cancellable?.cancel()
    }
}
