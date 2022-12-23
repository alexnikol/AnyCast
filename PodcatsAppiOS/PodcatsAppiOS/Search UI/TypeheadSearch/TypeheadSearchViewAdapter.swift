// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedComponentsiOSModule
import Combine
import LoadResourcePresenter
import SearchContentModule
import SearchContentModuleiOS

final class TypeheadSearchViewAdapter: ResourceView {
    typealias ResourceViewModel = TypeheadSearchContentResultViewModel
    
    weak var controller: ListViewController?
    private let onTermSelect: (String) -> Void
    
    init(controller: ListViewController, onTermSelect: @escaping (String) -> Void) {
        self.controller = controller
        self.onTermSelect = onTermSelect
    }
    
    func display(_ viewModel: ResourceViewModel) {
        let termControllers = viewModel.terms.map { term -> TermCellController in
            let termViewModel = TypeheadSearchContentPresenter.map(term)
            return TermCellController(model: termViewModel, selection: { [weak self] in
                self?.controller?.dismiss(animated: true)
                self?.onTermSelect(term)
            })
        }
        
        let section = DefaultSectionWithNoHeaderAndFooter(cellControllers: termControllers)
        controller?.display([section])
    }
}
