// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public struct ListTableViewConfiguratior {
    public let separatorStyle: UITableViewCell.SeparatorStyle
    public let sectionHeaderHeight: CGFloat
    public let sectionFooterHeight: CGFloat
    public let backgroundColor: UIColor
    public let tableStyle: UITableView.Style
    
    public static var `default`: ListTableViewConfiguratior {
        ListTableViewConfiguratior(
            separatorStyle: .none,
            sectionHeaderHeight: UITableView.automaticDimension,
            sectionFooterHeight: UITableView.automaticDimension,
            backgroundColor: .systemBackground,
            tableStyle: .grouped
        )
    }
    
    public init(separatorStyle: UITableViewCell.SeparatorStyle,
                sectionHeaderHeight: CGFloat,
                sectionFooterHeight: CGFloat,
                backgroundColor: UIColor,
                tableStyle: UITableView.Style) {
        self.separatorStyle = separatorStyle
        self.sectionHeaderHeight = sectionHeaderHeight
        self.sectionFooterHeight = sectionFooterHeight
        self.backgroundColor = backgroundColor
        self.tableStyle = tableStyle
    }
}
