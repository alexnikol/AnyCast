// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SearchContentModule
import LoadResourcePresenter
import SharedComponentsiOSModule

public final class TermCellController: NSObject {
    private let model: TypeaheadSearchTermViewModel
    private var cell: UITableViewCell?
    private let selection: () -> Void
    
    public init(model: TypeaheadSearchTermViewModel,
                selection: @escaping () -> Void) {
        self.model = model
        self.selection = selection
    }
        
    private func releaseCellForResuse() {
        cell = nil
    }
}

extension TermCellController: CellController {
    public var delegate: UITableViewDelegate? {
        return self
    }
    
    public var dataSource: UITableViewDataSource {
        return self
    }
    
    public var prefetchingDataSource: UITableViewDataSourcePrefetching? {
        return nil
    }
}

extension TermCellController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection()
    }
}

extension TermCellController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueAndRegisterCell(indexPath: indexPath) as UITableViewCell
        cell?.textLabel!.text = model
        return cell!
    }
}

extension UITableViewCell: Reusable {}
