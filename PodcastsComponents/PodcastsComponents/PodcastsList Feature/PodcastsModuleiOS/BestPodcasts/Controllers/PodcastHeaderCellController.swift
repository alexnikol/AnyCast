// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsModule

public final class PodcastHeaderCellController: NSObject, SectionController {
    public var dataSource: UITableViewDataSource { self }
    public var delegate: UITableViewDelegate? { self }
    public var prefetchingDataSource: UITableViewDataSourcePrefetching?
    public var cellControllers: [CellController]
    public let viewModel: PodcastDetailsViewModel
    
    public init(cellControllers: [CellController], viewModel: PodcastDetailsViewModel) {
        self.cellControllers = cellControllers
        self.viewModel = viewModel
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
        header.titleLabel.text = viewModel.title
        header.authorLabel.text = viewModel.publisher
        header.imageInnerContainer.isShimmering = true
        return header
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
