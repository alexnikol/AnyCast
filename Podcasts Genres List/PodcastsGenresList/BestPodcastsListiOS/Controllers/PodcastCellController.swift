// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import BestPodcastsList

final class PodcastCellController {
        
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
