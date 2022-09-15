// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList

final class GenreCellController {
    
    private let model: GenreViewModel
    
    init(model: GenreViewModel) {
        self.model = model
    }
    
    func view(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GenreCell = collectionView.dequeueAndRegisterCell(indexPath: indexPath)
        cell.nameLabel.text = model.name
        return cell
    }
}
