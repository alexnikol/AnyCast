// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import BestPodcastsList

public final class BestPodcastsListViewController: UITableViewController {
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
        
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
            
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellModels[indexPath.row].view(tableView, cellForRowAt: indexPath)
    }
}
