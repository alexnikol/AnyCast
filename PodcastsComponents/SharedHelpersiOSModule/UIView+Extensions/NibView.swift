// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public class NibView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(loadXibView(with: frame))
        setupView()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(loadXibView(with: bounds))
        setupView()
    }
    public func setupView() {}
}
