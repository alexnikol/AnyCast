// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule
import SearchContentModule

public final class SearchResultPodcastCellController: NSObject {
    public typealias ResourceViewModel = UIImage
    
    private let model: SearchResultPodcastViewModel
    private var cell: SearchPodcastCell?
    private let selection: () -> Void
    private var thumbnailViewController: ThumbnailViewController?
    
    public init(model: SearchResultPodcastViewModel,
                thumbnailViewController: ThumbnailViewController,
                selection: @escaping () -> Void) {
        self.model = model
        self.thumbnailViewController = thumbnailViewController
        self.selection = selection
    }
    
    func preload() {
        thumbnailViewController?.didRequestLoading()
    }
    
    func cancelLoad() {
        thumbnailViewController?.didRequestCancel()
        releaseCellForResuse()
    }
    
    private func releaseCellForResuse() {
        cell = nil
    }
}

extension SearchResultPodcastCellController: CellController {
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

extension SearchResultPodcastCellController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelLoad()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection()
    }
}

extension SearchResultPodcastCellController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueAndRegisterNibCell(indexPath: indexPath) as SearchPodcastCell
        cell?.titleLabel.text = model.title
        cell?.publisherLabel.text = model.publisher
        thumbnailViewController?.view = cell?.thumbnailImageView

        thumbnailViewController?.didRequestLoading()
        return cell!
    }
}

extension SearchResultPodcastCellController: UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        preload()
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        cancelLoad()
    }
}
