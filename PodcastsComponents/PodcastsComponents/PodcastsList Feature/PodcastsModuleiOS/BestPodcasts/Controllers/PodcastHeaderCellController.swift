// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule
import LoadResourcePresenter
import PodcastsModule

public final class PodcastHeaderCellController: NSObject, SectionController {
    public typealias ResourceViewModel = UIImage
    
    public var dataSource: UITableViewDataSource { self }
    public var delegate: UITableViewDelegate? { self }
    public var prefetchingDataSource: UITableViewDataSourcePrefetching?
    private let imageLoaderDelegate: RefreshViewControllerDelegate
    public var cellControllers: [CellController]
    public let viewModel: PodcastDetailsViewModel
    private var podcastHeader: PodcastHeaderReusableView?
    
    public init(cellControllers: [CellController],
                viewModel: PodcastDetailsViewModel,
                imageLoaderDelegate: RefreshViewControllerDelegate) {
        self.cellControllers = cellControllers
        self.viewModel = viewModel
        self.imageLoaderDelegate = imageLoaderDelegate
    }
}

extension PodcastHeaderCellController: UITableViewDataSource, UITableViewDelegate {
        
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellControllers.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellControllers[indexPath.row].dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: PodcastHeaderReusableView = tableView.dequeueAndRegisterReusableView()
        podcastHeader = header
        podcastHeader?.titleLabel.text = viewModel.title
        podcastHeader?.authorLabel.text = viewModel.publisher
        
        imageLoaderDelegate.didRequestLoading()
        return header
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        cancelLoadImage()
    }
    
    private func cancelLoadImage() {
        imageLoaderDelegate.didRequestCancel()
        releaseReusableViewForResuse()
    }
    
    private func releaseReusableViewForResuse() {
        podcastHeader = nil
    }
}

extension PodcastHeaderCellController: ResourceView {
    
    public func display(_ viewModel: ResourceViewModel) {
        podcastHeader?.imageView.image = viewModel
    }
}

extension PodcastHeaderCellController: ResourceLoadingView {
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        podcastHeader?.imageInnerContainer.isShimmering = viewModel.isLoading
    }
}

extension PodcastHeaderCellController: ResourceErrorView {
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        podcastHeader?.imageView.image = nil
    }
}
