// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsModule
import LoadResourcePresenter

public protocol PodcastCellControllerDelegate {
    func didRequestImage()
    func didCancelImageLoad()
}

public final class PodcastCellController: NSObject {
    public typealias ResourceViewModel = UIImage
    
    private let model: PodcastImageViewModel
    private let cellDelegate: PodcastCellControllerDelegate
    private var cell: PodcastCell?
    private let selection: () -> Void
    
    public init(model: PodcastImageViewModel,
                delegete: PodcastCellControllerDelegate,
                selection: @escaping () -> Void) {
        self.model = model
        self.cellDelegate = delegete
        self.selection = selection
    }

    func cancelLoad() {
        cellDelegate.didCancelImageLoad()
        releaseCellForResuse()
    }
    
    func preload() {
        cellDelegate.didRequestImage()
    }
    
    private func releaseCellForResuse() {
        cell = nil
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

extension PodcastCellController: CellController {
    public var delegate: UITableViewDelegate? {
        return self
    }
    
    public var dataSource: UITableViewDataSource {
        return self
    }
    
    public var prefetchingDataSource: UITableViewDataSourcePrefetching? {
        return self
    }
}

extension PodcastCellController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelLoad()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("HERE__")
        selection()
    }
}

extension PodcastCellController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueAndRegisterCell(indexPath: indexPath) as PodcastCell
        cell?.titleLabel.text = model.title
        cell?.publisherLabel.text = model.publisher
        cell?.languageStaticLabel.text = model.languageStaticLabel
        cell?.languageValueLabel.text = model.languageValueLabel
        cell?.typeValueLabel.text = model.typeValueLabel
        cell?.typeStaticLabel.text = model.typeStaticLabel
        cell?.thumbnailImageView.image = nil

        cellDelegate.didRequestImage()
        return cell!
    }
}

extension PodcastCellController: UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        preload()
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        cancelLoad()
    }
}
