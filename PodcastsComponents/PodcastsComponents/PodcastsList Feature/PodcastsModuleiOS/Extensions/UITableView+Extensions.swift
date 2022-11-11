// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

extension UITableView {
    func dequeueAndRegisterCell<Cell>(indexPath: IndexPath) -> Cell where Cell: UITableViewCell & NibReusable {
        registerCell(type: Cell.self)
        return dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
    }
    
    func registerCell<Cell>(type: Cell.Type) where Cell: UITableViewCell & NibReusable {
        register(UINib(nibName: Cell.reuseIdentifier, bundle: Bundle(for: Cell.self)), forCellReuseIdentifier: Cell.reuseIdentifier)
    }
}
