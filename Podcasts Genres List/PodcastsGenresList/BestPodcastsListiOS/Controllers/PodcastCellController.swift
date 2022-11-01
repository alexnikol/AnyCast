// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import BestPodcastsList
import LoadResourcePresenter

protocol PodcastCellControllerDelegate {
    func didRequestImage()
}

public final class PodcastCellController {
    private let model: Podcast
    private let delegate: PodcastCellControllerDelegate
    
    init(model: Podcast, delegete: PodcastCellControllerDelegate) {
        self.model = model
        self.delegate = delegete
    }
    
    func view(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PodcastCell = tableView.dequeueAndRegisterCell(indexPath: indexPath)
        cell.titleLabel.text = model.title
        delegate.didRequestImage()
        return cell
    }
}

extension PodcastCellController: ResourceView {
    public typealias ResourceViewModel = PodcastImageViewModel
    
    public func display(_ viewModel: ResourceViewModel) {
        
    }
}

extension PodcastCellController: ResourceLoadingView {
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        
    }
}
