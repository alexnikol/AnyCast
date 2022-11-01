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
    private var cell: PodcastCell?
    
    init(model: Podcast, delegete: PodcastCellControllerDelegate) {
        self.model = model
        self.delegate = delegete
    }
    
    func view(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueAndRegisterCell(indexPath: indexPath) as PodcastCell
        cell?.titleLabel.text = model.title
        delegate.didRequestImage()
        return cell!
    }
}

extension PodcastCellController: ResourceView {
    public typealias ResourceViewModel = PodcastImageViewModel<UIImage>
    
    public func display(_ viewModel: ResourceViewModel) {}
}

extension PodcastCellController: ResourceLoadingView {
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        
    }
}
