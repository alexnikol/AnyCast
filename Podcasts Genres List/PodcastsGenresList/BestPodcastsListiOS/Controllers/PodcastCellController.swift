// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import BestPodcastsList
import LoadResourcePresenter

protocol PodcastCellControllerDelegate {
    func didRequestImage()
    func didCancelImageLoad()
}

public final class PodcastCellController {
    public typealias ResourceViewModel = UIImage
    
    private let model: PodcastImageViewModel<UIImage>
    private let delegate: PodcastCellControllerDelegate
    private var cell: PodcastCell?
    
    init(model: PodcastImageViewModel<UIImage>, delegete: PodcastCellControllerDelegate) {
        self.model = model
        self.delegate = delegete
    }
    
    func view(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueAndRegisterCell(indexPath: indexPath) as PodcastCell
        cell?.titleLabel.text = model.title
        delegate.didRequestImage()
        return cell!
    }
    
    func cancelLoad() {
        delegate.didCancelImageLoad()
    }
    
    func preload() {
        delegate.didRequestImage()
    }
}

extension PodcastCellController: ResourceView {
    
    public func display(_ viewModel: ResourceViewModel) {
        cell?.thumbnailImageView.image = viewModel
    }
}

extension PodcastCellController: ResourceLoadingView {
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell?.container.isShimmering = viewModel.isLoading
    }
}
