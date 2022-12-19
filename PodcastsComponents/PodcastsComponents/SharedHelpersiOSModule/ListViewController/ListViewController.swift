// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public protocol SectionController: CellController {
    var cellControllers: [CellController] { get }
}

public protocol CellController {
    var delegate: UITableViewDelegate? { get }
    var dataSource: UITableViewDataSource { get }
    var prefetchingDataSource: UITableViewDataSourcePrefetching? { get }
}

public final class ListViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private var sectionsController: [SectionController] = []
    private var refreshController: RefreshViewController?
    private var sections: [SectionController] = [DefaultSectionWithNoHeaderAndFooter(cellControllers: [])]
    private let tableConfig: ListTableViewConfiguratior
    
    public init(refreshController: RefreshViewController, tableConfig: ListTableViewConfiguratior = .default) {
        self.refreshController = refreshController
        self.tableConfig = tableConfig
        super.init(style: tableConfig.tableStyle)
    }
    
    public func display(_ models: [SectionController]) {
        sections = models
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.prefetchDataSource = self
        tableView.separatorStyle = tableConfig.separatorStyle
        tableView.sectionHeaderHeight = tableConfig.sectionHeaderHeight
        tableView.sectionFooterHeight = tableConfig.sectionFooterHeight
        tableView.backgroundColor = tableConfig.backgroundColor
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sections[section].delegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].dataSource.tableView?(tableView, titleForHeaderInSection: section)
    }
    
    override public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sections[section].delegate?.tableView?(tableView, heightForHeaderInSection: section) ?? 0.0
    }
    
    override public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        sections[section].delegate?.tableView?(tableView, viewForFooterInSection: section)
    }
    
    override public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        sections[section].dataSource.tableView?(tableView, titleForFooterInSection: section)
    }
    
    override public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        sections[section].delegate?.tableView?(tableView, heightForFooterInSection: section) ?? 0.0
    }
            
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].dataSource.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellController(for: indexPath).delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(for: indexPath).dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellController(for: indexPath).delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(for: indexPath).prefetchingDataSource?.tableView(tableView, prefetchRowsAt: indexPaths)
        }
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(for: indexPath).prefetchingDataSource?.tableView?(tableView, cancelPrefetchingForRowsAt: indexPaths)
        }
    }
    
    override public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        sections[section].delegate?.tableView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
    }
        
    private func cellController(for indexPath: IndexPath) -> CellController {
        sections[indexPath.section].cellControllers[indexPath.row]
    }
}
