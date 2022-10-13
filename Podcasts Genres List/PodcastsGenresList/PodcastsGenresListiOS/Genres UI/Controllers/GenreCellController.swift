// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList

public final class GenreCellController {
    
    private let model: GenreCellViewModel
    
    public init(model: GenreCellViewModel) {
        self.model = model
    }
    
    func view(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GenreCell = collectionView.dequeueAndRegisterCell(indexPath: indexPath)
        cell.nameLabel.text = model.name
        cell.tagView.backgroundColor = model.color
        return cell
    }
}
