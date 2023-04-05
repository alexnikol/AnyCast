// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule
import LoadResourcePresenter
import SearchContentModule

public final class TitleHeaderViewCellController: NSObject, SectionController {
    public var dataSource: UITableViewDataSource { self }
    public var delegate: UITableViewDelegate? { self }
    public var prefetchingDataSource: UITableViewDataSourcePrefetching?
    public var cellControllers: [CellController]
    public let viewModel: TitleHeaderViewModel
    private var podcastHeader: TitleHeaderReusableView?
    
    public init(cellControllers: [CellController],
                viewModel: TitleHeaderViewModel) {
        self.cellControllers = cellControllers
        self.viewModel = viewModel
    }
}

extension TitleHeaderViewCellController: UITableViewDataSource, UITableViewDelegate {
        
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellControllers.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellControllers[indexPath.row].dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: TitleHeaderReusableView = tableView.dequeueAndRegisterReusableView()
        podcastHeader = header
        podcastHeader?.titleLabel.text = viewModel.title
        podcastHeader?.descriptionLabel.text = viewModel.description
        podcastHeader?.descriptionLabel.isHidden = viewModel.description == nil
        return header
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}
