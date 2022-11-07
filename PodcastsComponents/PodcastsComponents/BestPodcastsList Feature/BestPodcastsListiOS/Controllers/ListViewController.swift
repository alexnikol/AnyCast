// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public protocol CellController {
    var delegate: UITableViewDelegate? { get }
    var dataSource: UITableViewDataSource { get }
    var prefetchingDataSource: UITableViewDataSourcePrefetching? { get }
}

public final class ListViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private var cellModels: [CellController] = []
    private var refreshController: RefreshViewController?
    
    public init(refreshController: RefreshViewController) {
        self.refreshController = refreshController
        super.init(style: .plain)
    }
    
    public func display(_ models: [CellController]) {
        cellModels = models
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.prefetchDataSource = self
        tableView.separatorStyle = .none
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
            
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellModels[indexPath.row].dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellModels[indexPath.row].delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            cellModels[$0.row].prefetchingDataSource?.tableView(tableView, prefetchRowsAt: indexPaths)
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            cellModels[$0.row].prefetchingDataSource?.tableView?(tableView, cancelPrefetchingForRowsAt: indexPaths)
        }
    }
}
