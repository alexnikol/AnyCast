// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import LoadResourcePresenter
import SearchContentModule

final class GeneralSearchPresentationAdapter: GeneralSearchSourceDelegate {
    typealias Resource = GeneralSearchContentResult
    
    private var cancellable: AnyCancellable?
    private let loader: (String) -> AnyPublisher<Resource, Error>
    var presenter: LoadResourcePresenter<Resource, GeneralSearchViewAdapter>?
    
    init(loader: @escaping (String) -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    func didUpdateSearchTerm(_ term: String) {
        didRequestLoading(term: term)
    }
    
    private func didRequestLoading(term: String) {
        cancellable?.cancel()
        presenter?.didStartLoading()
        cancellable = loader(term)
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
}
