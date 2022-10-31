// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import BestPodcastsList

class PodcastCellController {
        
    private let model: Podcast
    
    init(model: Podcast) {
        self.model = model
    }
    
    func view(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PodcastCell.self)) as! PodcastCell
        cell.titleLabel.text = model.title
        return cell
    }
}

public final class BestPodcastsListViewController: UITableViewController {
    private var loader: BestPodcastsLoader
    private var genreID: Int
    private var cellModels: [PodcastCellController] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
        
        tableView.register(PodcastCell.self, forCellReuseIdentifier: String(describing: PodcastCell.self))
        
        refresh()
    }
    
    @objc
    private func refresh() {
        refreshControl?.beginRefreshing()
        loader.load(by: genreID, completion: { [weak self] result in
            guard let self = self else { return }
            
            if let data = try? result.get() {
                self.cellModels = data.podcasts.map { podcast in PodcastCellController(model: podcast) }
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
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
        return cellModels.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellModels[indexPath.row].view(tableView, cellForRowAt: indexPath)
    }
}
