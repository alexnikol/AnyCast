// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import LoadResourcePresenter
import SearchContentModule
import SearchContentModuleiOS

final class TypeheadSearchPresentationAdapter: TypeheadListViewControllerDelegate {
    typealias Resource = TypeheadSearchContentResult
    
    private let loader: (String) -> AnyPublisher<Resource, Error>
    private var cancellable: AnyCancellable?
    var presenter: LoadResourcePresenter<Resource, TypeheadSearchViewAdapter>?
    
    init(loader: @escaping (String) -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    func searchTextDidChange(term: String) {
        didRequestCancel()
        didRequestLoading(term: term)
    }
    
    private func didRequestLoading(term: String) {
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
    
    private func didRequestCancel() {
        cancellable?.cancel()
    }
}
