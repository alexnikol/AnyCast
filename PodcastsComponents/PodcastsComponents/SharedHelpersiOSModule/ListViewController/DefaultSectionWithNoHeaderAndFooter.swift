// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public final class DefaultSectionWithNoHeaderAndFooter: NSObject, SectionController {
    public let cellControllers: [CellController]
    public var dataSource: UITableViewDataSource { self }
    public weak var delegate: UITableViewDelegate? { self }
    public weak var prefetchingDataSource: UITableViewDataSourcePrefetching? { nil }
    
    public init(cellControllers: [CellController]) {
        self.cellControllers = cellControllers
    }
}

extension DefaultSectionWithNoHeaderAndFooter: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellControllers.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellControllers[indexPath.row].dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
}
