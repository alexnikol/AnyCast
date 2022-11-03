// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList

public final class GenreCellController {
    
    private let model: GenreCellViewModel
    private let selection: () -> Void
    
    public init(model: GenreCellViewModel, selection: @escaping () -> Void) {
        self.model = model
        self.selection = selection
    }
    
    func view(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GenreCell = collectionView.dequeueAndRegisterCell(indexPath: indexPath)
        cell.nameLabel.text = model.name
        cell.tagView.backgroundColor = model.color
        return cell
    }
    
    func didSelect() {
        selection()
    }
}
