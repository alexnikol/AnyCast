// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule
import SearchContentModule
import PodcastsModuleiOS

public final class SearchEpisodeCellController: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let viewModel: SearchResultEpisodeViewModel
    private var cell: EpisodeCell?
    private let selection: () -> Void
    
    public init(viewModel: SearchResultEpisodeViewModel, selection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.selection = selection
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueAndRegisterNibCell(indexPath: indexPath) as EpisodeCell
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

extension SearchEpisodeCellController: CellController {
    public var delegate: UITableViewDelegate? { self }
    public var dataSource: UITableViewDataSource { self }
    public var prefetchingDataSource: UITableViewDataSourcePrefetching? { nil }
}
