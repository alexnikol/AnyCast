// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsModule

public final class EpisodeCellController: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let viewModel: EpisodeViewModel
    private var cell: EpisodeCell?
    private let selection: () -> Void
    
    public init(viewModel: EpisodeViewModel, selection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.selection = selection
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueAndRegisterCell(indexPath: indexPath) as EpisodeCell
        cell?.titleLabel.text = viewModel.title
        cell?.updateDescription(viewModel.descriptionWithHTMLMarkup)
        cell?.audioLengthLabel.text = viewModel.displayAudioLengthInSeconds
        cell?.publishDateLabel.text = viewModel.displayPublishDate
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection()
    }
}

extension EpisodeCellController: CellController {
    public var delegate: UITableViewDelegate? { self }
    public var dataSource: UITableViewDataSource { self }
    public var prefetchingDataSource: UITableViewDataSourcePrefetching? { nil }
}
