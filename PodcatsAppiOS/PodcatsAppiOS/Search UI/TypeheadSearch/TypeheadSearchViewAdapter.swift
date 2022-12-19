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
    
    init(controller: ListViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: ResourceViewModel) {
        let termsViewModels = TypeheadSearchContentPresenter.map(viewModel.terms)
        let termControllers = termsViewModels.map { termViewModel -> TermCellController in
            TermCellController(model: termViewModel, selection: {
                print("SELECTION \(termViewModel)")
            })
        }
        
        let section = DefaultSectionWithNoHeaderAndFooter(cellControllers: termControllers)
        controller?.display([section])
    }
}
