// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

extension UICollectionView {
    func dequeueAndRegisterCell<Cell>(indexPath: IndexPath) -> Cell where Cell: UICollectionViewCell & Reusable {
        registerCell(type: Cell.self)
        return dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
    }
    
    func registerCell<Cell>(type: Cell.Type) where Cell: UICollectionViewCell & Reusable {
        register(type, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
}
