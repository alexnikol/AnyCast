// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import BestPodcastsList

class PodcastCellController {}

public final class BestPodcastsListViewController: UITableViewController {
    private var loader: BestPodcastsLoader
    private var genreID: Int
    private var cells: [PodcastCellController] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
        refresh()
    }
    
    @objc
    private func refresh() {
        loader.load(by: genreID, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(data):
                self.cells = data.podcasts.map { _ in PodcastCellController() }
                self.tableView.reloadData()
            case .failure:
                break
            }
        })
    }
    
    public init(genreID: Int, loader: BestPodcastsLoader) {
        self.genreID = genreID
        self.loader = loader
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
