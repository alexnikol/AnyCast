// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresListiOS

extension GenresListViewController {
    
    private var genresSection: Int {
        return 0
    }
    
    func simulateGenreHighlightState(at index: Int, isHighlight: Bool) {
        let delegate = collectionView.delegate
        let indexPath = IndexPath(row: index, section: genresSection)
        if isHighlight {
            delegate?.collectionView?(collectionView, didHighlightItemAt: indexPath)
        } else {
            delegate?.collectionView?(collectionView, didUnhighlightItemAt: indexPath)
        }
    }
}
