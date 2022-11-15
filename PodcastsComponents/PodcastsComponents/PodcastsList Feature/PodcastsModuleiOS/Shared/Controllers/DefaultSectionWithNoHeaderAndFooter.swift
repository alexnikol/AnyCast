// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public final class DefaultSectionWithNoHeaderAndFooter: NSObject, SectionController {
    public var cellControllers: [CellController]
    public weak var delegate: UITableViewDelegate? { nil }
    public weak var prefetchingDataSource: UITableViewDataSourcePrefetching? { nil }
    
    public init(cellControllers: [CellController]) {
        self.cellControllers = cellControllers
    }
}
