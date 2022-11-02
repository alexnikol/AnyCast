// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import BestPodcastsList
import LoadResourcePresenter

public protocol PodcastCellControllerDelegate {
    func didRequestImage()
    func didCancelImageLoad()
}

public final class PodcastCellController {
    public typealias ResourceViewModel = UIImage
    
    private let model: PodcastImageViewModel
    private let delegate: PodcastCellControllerDelegate
    private var cell: PodcastCell?
    
    public init(model: PodcastImageViewModel, delegete: PodcastCellControllerDelegate) {
        self.model = model
        self.delegate = delegete
    }
    
    func view(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueAndRegisterCell(indexPath: indexPath) as PodcastCell
        cell?.titleLabel.text = model.title
        cell?.publisherLabel.text = model.publisher
        cell?.languageStaticLabel.text = model.languageStaticLabel
        cell?.languageValueLabel.text = model.languageValueLabel
        cell?.typeValueLabel.text = model.typeValueLabel
        cell?.typeStaticLabel.text = model.typeStaticLabel

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
        cell?.imageContainer.isShimmering = viewModel.isLoading
    }
}

extension PodcastCellController: ResourceErrorView {
    public func display(_ viewModel: ResourceErrorViewModel) {
        cell?.thumbnailImageView.image = nil
    }
}
