// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList

public final class GenreCellController {
    
    private let model: GenreCellViewModel
    private let selection: () -> Void
    private var cell: GenreCell?
    
    public init(model: GenreCellViewModel, selection: @escaping () -> Void) {
        self.model = model
        self.selection = selection
    }
    
    func view(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueAndRegisterCell(indexPath: indexPath) as GenreCell
        cell?.nameLabel.text = model.name
        cell?.tagView.backgroundColor = model.color
        return cell!
    }
    
    func didSelect() {
        selection()
    }
    
    func updateHighlight(_ isHighlight: Bool) {
        cell?.updateHighlighted(isHighlight)
    }
}
