// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsModule

public final class EpisodeCellController: NSObject, UITableViewDataSource {
    private let viewModel: EpisodeViewModel
    private var cell: EpisodeCell?
    
    public init(viewModel: EpisodeViewModel) {
        self.viewModel = viewModel
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueAndRegisterCell(indexPath: indexPath) as EpisodeCell
        cell?.titleLabel.text = viewModel.title
        cell?.descriptionLabel.text = viewModel.description
        cell?.audioLengthLabel.text = viewModel.displayAudioLengthInSeconds
        cell?.publishDateLabel.text = viewModel.displayPublishDate
        return cell!
    }
}

extension EpisodeCellController: CellController {
    public var delegate: UITableViewDelegate? { nil }
    public var dataSource: UITableViewDataSource { self }
    public var prefetchingDataSource: UITableViewDataSourcePrefetching? { nil }
}
