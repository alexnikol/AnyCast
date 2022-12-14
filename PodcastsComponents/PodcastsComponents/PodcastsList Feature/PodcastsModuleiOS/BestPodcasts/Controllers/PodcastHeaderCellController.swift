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
    public var cellControllers: [CellController]
    public let viewModel: PodcastDetailsViewModel
    private var podcastHeader: PodcastHeaderReusableView?
    private var thumbnailViewController: ThumbnailViewController?
    
    public init(cellControllers: [CellController],
                viewModel: PodcastDetailsViewModel,
                thumbnailViewController: ThumbnailViewController) {
        self.cellControllers = cellControllers
        self.viewModel = viewModel
        self.thumbnailViewController = thumbnailViewController
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
        thumbnailViewController?.view = header.imageView
        podcastHeader = header
        podcastHeader?.titleLabel.text = viewModel.title
        podcastHeader?.authorLabel.text = viewModel.publisher
        
        thumbnailViewController?.didRequestLoading()
        return header
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        cancelLoadImage()
    }
    
    private func cancelLoadImage() {
        thumbnailViewController?.didRequestCancel()
        releaseReusableViewForResuse()
    }
    
    private func releaseReusableViewForResuse() {
        podcastHeader = nil
    }
}
