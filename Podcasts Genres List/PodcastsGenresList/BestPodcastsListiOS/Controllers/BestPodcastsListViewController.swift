// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import BestPodcastsList

public final class BestPodcastsListViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private var cellModels: [PodcastCellController] = []
    private var refreshController: BestPodcastsListRefreshViewController?
    
    public init(refreshController: BestPodcastsListRefreshViewController) {
        self.refreshController = refreshController
        super.init(style: .plain)
    }
    
    public func display(_ models: [PodcastCellController]) {
        cellModels = models
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.prefetchDataSource = self
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
            
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellModels[indexPath.row].view(tableView, cellForRowAt: indexPath)
    }
    
    override public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            cellController(forRowAt: $0).preload()
        }
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> PodcastCellController {
        let cellController = cellModels[indexPath.row]
        return cellController
    }
}
