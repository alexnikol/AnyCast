// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedComponentsiOSModule
import Combine
import LoadResourcePresenter
import SearchContentModule
import SearchContentModuleiOS
import PodcastsModuleiOS

final class GeneralSearchViewAdapter: ResourceView {
    typealias ResourceViewModel = GeneralSearchContentResultViewModel
    
    weak var controller: ListViewController?
    
    init(controller: ListViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: ResourceViewModel) {
        let episodesCells = viewModel.episodes.map { episode in
            let episodeViewModel = GeneralSearchContentPresenter.map(episode)
            return EpisodeCellController(viewModel: episodeViewModel, selection: {})
        }
        let section = DefaultSectionWithNoHeaderAndFooter(cellControllers: episodesCells)
        let sections: [SectionController] = [section]
        
        controller?.display(sections)
    }
}
