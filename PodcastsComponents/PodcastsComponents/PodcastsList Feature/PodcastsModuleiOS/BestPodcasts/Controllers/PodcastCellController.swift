// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsModule
import LoadResourcePresenter
import SharedComponentsiOSModule

public final class PodcastCellController: NSObject {
    public typealias ResourceViewModel = UIImage
    
    private let model: PodcastImageViewModel
    private var cell: PodcastCell?
    private let selection: () -> Void
    private var thumbnailViewController: ThumbnailViewController?
    
    public init(model: PodcastImageViewModel,
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
        selection()
    }
}

extension PodcastCellController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueAndRegisterNibCell(indexPath: indexPath) as PodcastCell
        cell?.titleLabel.text = model.title
        cell?.publisherLabel.text = model.publisher
        cell?.languageStaticLabel.text = model.languageStaticLabel
        cell?.languageValueLabel.text = model.languageValueLabel
        cell?.typeValueLabel.text = model.typeValueLabel
        cell?.typeStaticLabel.text = model.typeStaticLabel
        thumbnailViewController?.view = cell?.thumbnailImageView

        thumbnailViewController?.didRequestLoading()
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
