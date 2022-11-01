// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

extension UITableView {
    func dequeueAndRegisterCell<Cell>(indexPath: IndexPath) -> Cell where Cell: UITableViewCell & Reusable {
        registerCell(type: Cell.self)
        return dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
    }
    
    func registerCell<Cell>(type: Cell.Type) where Cell: UITableViewCell & Reusable {
        register(type, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
}
