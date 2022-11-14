// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public extension UITableView {
    func dequeueAndRegisterCell<Cell>(indexPath: IndexPath) -> Cell where Cell: UITableViewCell & Reusable {
        registerCell(type: Cell.self)
        return dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
    }
    
    func registerCell<Cell>(type: Cell.Type) where Cell: UITableViewCell & Reusable {
        register(UINib(nibName: Cell.reuseIdentifier, bundle: Bundle(for: Cell.self)), forCellReuseIdentifier: Cell.reuseIdentifier)
    }
}
