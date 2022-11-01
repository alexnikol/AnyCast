// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import BestPodcastsList

public final class PodcastCellController {
        
    private let model: Podcast
    
    init(model: Podcast) {
        self.model = model
    }
    
    func view(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PodcastCell = tableView.dequeueAndRegisterCell(indexPath: indexPath)
        cell.titleLabel.text = model.title
        return cell
    }
}
